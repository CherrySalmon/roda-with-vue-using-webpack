<template>
  <div>
    <div class="login-container">Login</div>
    <div style="display: flex;justify-content: center;">
      <div id="google-sign-in-button"></div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import Cookies from 'js-cookie';
import { ElNotification } from 'element-plus'
export default {
  name: 'LoginPage',

  data() {
    return {
      googleClientId: process.env.VUE_APP_GOOGLE_CLIENT_ID,
    };
  },
  mounted() {
    window.google.accounts.id.initialize({
        client_id: process.env.VUE_APP_GOOGLE_CLIENT_ID,
        callback: this.handleCallback
      })
      window.google.accounts.id.renderButton(
        document.getElementById("google-sign-in-button"),
        {
          theme: "outline",
          size: "large",
          shape: "pill",
        }
      )
  },
  methods: {
    async fetchLoginToken(userData) {
      try {
        const { status, data } = await axios.post('/api/auth/verify_google_token', { user_data: userData });
        if (status === 200 || status === 201) {
          this.setUserInfoCookies(data.user_info);
          if (this.$route.query.redirect && this.$route.query.redirect!='/' ) {
            this.$router.push(this.$route.query.redirect)
          }
          else {
            this.$router.push('/course')
          }
        } 
      } catch (error) {
        console.error('Error:', error.response || error);
        ElNotification({
          title: 'Error',
          message: 'Account not found, please contact your teaching staff.',
          type: 'error',
        })
      }
    },
    async handleCallback(response) {
      let userData = this.parseJwt(response.credential);
      userData['sso_token'] = response.access_token
      await this.fetchLoginToken(userData);
    },
    parseJwt(token) {
      const base64Url = token.split('.')[1];
      const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
      const jsonPayload = decodeURIComponent(window.atob(base64).split('').map(c => 
        `%${('00' + c.charCodeAt(0).toString(16)).slice(-2)}`
      ).join(''));

      return JSON.parse(jsonPayload);
    },
    setUserInfoCookies(user_info) {
      const expDay = 7;
      Cookies.set('account_id', user_info.id, { expires: expDay });
      Cookies.set('account_roles', user_info.roles.join(','), { expires: expDay });
      Cookies.set('account_credential', user_info.credential, { expires: expDay });
      Cookies.set('account_img', user_info.avatar, { expires: expDay })
      Cookies.set('account_name', user_info.name, { expires: expDay })
    },
  },
};
</script>

<style scoped>
p {
  margin-top: 12px;
  word-break: break-all;
}

.signin-container {
  width: 400px;
  margin: auto;
  display: flex;
  justify-content: center;
  margin-top: 200px;
}

.login-container {
  font-size: 2.5rem;
  font-weight: 700;
  margin: 40px 0;
}
</style>

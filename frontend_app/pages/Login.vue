<template>
  <div>
    <div class="signin-container">
        <div id="g_id_onload"
            :data-client_id="googleClientId"
            data-context="signin"
            data-ux_mode="popup"
            data-callback="handleCallback"
            data-itp_support="true">
        </div>

        <div class="g_id_signin"
            data-type="standard"
            data-shape="pill"
            data-theme="outline"
            data-text="signin_with"
            data-size="large"
            data-logo_alignment="left">
        </div>
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
    // Attach handleCallback to window object when component mounts
    window.handleCallback = this.handleCallbackGlobal;
  },
  beforeDestroy() {
    // Clean up handleCallback from window object to avoid memory leaks
    if (window.handleCallback === this.handleCallbackGlobal) {
      delete window.handleCallback;
    }
  },
  methods: {
    async fetchLoginToken(userData) {
      try {
        const { status, data } = await axios.post('/api/auth/verify_google_token', { user_data: userData });
        if (status === 200 || status === 201) {
          this.setUserInfoCookies(data.user_info);
          if (this.$route.query.redirect) {
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
    handleCallbackGlobal(response) {
      // Delegate to component method
      this.handleCallback(response);
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
</style>

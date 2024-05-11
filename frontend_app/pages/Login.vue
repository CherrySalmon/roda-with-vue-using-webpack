<template>
  <div>
    <div class="login-container">Login</div>
    <div class="login-btn" @click="initiateServerSideAuth">
      <img class="login-icon-img" src="../static/google_icon.png" width="50" height="50"/>
      <div class="login-icon-text">Sign in with Google</div>
    </div>
    <el-button @click="testCookie()">Test Cookies Secure</el-button>
  </div>
</template>

<script>
import axios from 'axios'
import Cookies from 'js-cookie'
import { ElNotification } from 'element-plus'
import { googleTokenLogin } from 'vue3-google-login'
export default {
  name: 'LoginPage',

  data() {
    return {
    };
  },
  created() {
    this.handleQueryParameters();
  },
  methods: {
    testCookie() {
      axios.get(`/api/auth/cookie_test`).then(response => {
        let secret_cookie = Cookies.get('test_jwt')
        if (secret_cookie) {
          ElNotification({
            title: 'Secret Spill!',
            message: secret_cookie,
            type: 'error',
          });
        }
        else {
          ElNotification({
            title: 'Unable to access secret by JS',
            message: "Secret Secured!",
            type: 'success',
          });
        }
      }) 
      .catch(error => {
          console.error('Error fetching course name:', error);
          return 'Error fetching course name'; // Provide a fallback or error message
      });
    },
    initiateServerSideAuth() {
      // Redirect user to your server-side endpoint that starts the OAuth flow
      window.location.href = '/api/auth/google_login';
    },
    handleQueryParameters() {
      const query = this.$route.query;
      if (query.credential) {
        this.setUserInfoCookies(query);
        const path = query.redirect ? query.redirect : '/course';
        this.$router.push(path);
      } 
      else if (query.error) {
        ElNotification({
          title: 'Login Error',
          message: query.error,
          type: 'error',
        });
      }
    },    
    setUserInfoCookies(query) {
      const expDay = 180;
      Cookies.set('account_id', query.id, { expires: expDay });
      Cookies.set('account_roles', query.roles, { expires: expDay });
      Cookies.set('account_credential', query.credential, { expires: expDay });
      Cookies.set('account_img', query.avatar, { expires: expDay })
      Cookies.set('account_name', query.name, { expires: expDay })
    },
  },
};
</script>

<style scoped>
p {
  margin-top: 12px;
}

.login-container {
  font-size: 2.5rem;
  font-weight: 700;
  margin: 40px 0;
}
.login-btn {
  display: flex;
  justify-content: center;
  background-color: #fff;
  padding: 5px 5px;
  width: 260px;
  margin: auto;
  border-radius: 10px;
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);
}
.login-icon-img {
  display: inline;
}
.login-icon-text {
  display: inline;
  line-height: 50px;
  margin-left: 10px;
}
</style>

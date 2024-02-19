
<template>
    <div>
        <el-button type="primary" @click="handleGoogleAccessTokenLogin">
            使用 Google 進行登入
        </el-button>

    </div>
</template>

<script>
import { googleTokenLogin } from 'vue3-google-login';
import axios from 'axios';
import Cookies from 'js-cookie';

export default {
    name: 'LoginPage',

    data() {
        return {
            data: null,
            userData: null
        };
    },

    methods: {
        onLoginSuccess(account_info) {
            let exp_day = 7
            Cookies.set('account_id', account_info.id, { expires: exp_day });
            Cookies.set('account_roles', account_info.roles.join(','), { expires: exp_day });
            Cookies.set('account_credential', account_info.credential, { expires: exp_day });
        },
        async sendTokenToBackend(accessToken) {
            try {
                const response = await axios.post('/api/auth/verify_google_token', {
                    sso_token: accessToken
                });
                if (response.status === 200 || response.status === 201) {
                    return response.data;
                } else {
                    console.error('Error sending token to backend');
                }
            } catch (error) {
                console.error('Error:', error.response || error);
            }
        },
        async handleGoogleAccessTokenLogin() {
            try {
                const response = await googleTokenLogin({
                    clientId: process.env.VUE_APP_GOOGLE_CLIENT_ID,
                    scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile'
                });

                this.data = response;
                const userInfo = await this.sendTokenToBackend(response.access_token);
                this.userData = userInfo;
                if (userInfo) {
                    this.onLoginSuccess(userInfo.user_info)
                    this.$router.push('/home');
                }
            } catch (error) {
                console.error('Login Failed:', error);
            }
        }
    }
};
</script>


<style scoped>
p {
    margin-top: 12px;
    word-break: break-all;
}
</style>
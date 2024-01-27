
<template>
    <div>
        <button type="button" @click="handleGoogleAccessTokenLogin">
            使用 Google 進行登入
        </button>
    </div>
</template>

<script>
import { googleTokenLogin } from 'vue3-google-login';
import axios from 'axios';

export default {
    name: 'LoginPage',

    data() {
        return {
            data: null,
            userData: null
        };
    },

    methods: {
        async sendTokenToBackend(accessToken) {
            try {
                const response = await axios.post('/verify_google_token', {
                    access_token: accessToken
                });
                if (response.status === 200) {
                    console.log("User Info:", response.data);
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
                console.log('access_token:', response.access_token);
                const userInfo = await this.sendTokenToBackend(response.access_token);
                this.userData = userInfo;

                if (userInfo) {
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
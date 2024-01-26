<script setup>
import { ref } from 'vue'
import { googleTokenLogin } from 'vue3-google-login'
import axios from 'axios'
import { useRouter } from 'vue-router';

const router = useRouter();


const GOOGLE_CLIENT_ID = '324530495132-fdh8vl7jidbuv4d3bnu68qdja2jr798i.apps.googleusercontent.com'

const data = ref()
const userData = ref(null)

// Define sendTokenToBackend function
async function sendTokenToBackend(accessToken) {
    try {
        const response = await axios.post('/verify_google_token', {
            access_token: accessToken
        });
        if (response.status === 200) {
            console.log("User Info:", response.data);
            return response.data
        } else {
            console.error('Error sending token to backend');
        }
    } catch (error) {
        console.error('Error:', error.response || error);
        // Handle network errors or server errors
    }
}

// Modify handleGoogleAccessTokenLogin to use sendTokenToBackend
const handleGoogleAccessTokenLogin = async () => {
    try {
        const response = await googleTokenLogin({
            clientId: GOOGLE_CLIENT_ID,
            scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile'
        });

        data.value = response;
        console.log('access_token:', response.access_token)
        // Await the response from sendTokenToBackend
        const userInfo = await sendTokenToBackend(response.access_token);
        userData.value = userInfo; // Set userData to the actual user info
        // console.log(userData.value)
        if (userInfo) {
            router.push('/home'); // Redirect to the dashboard or another route
        }

    } catch (error) {
        console.error('Login Failed:', error);
    }
}

</script>

<template>
    <div>
        <button type="button" @click="handleGoogleAccessTokenLogin">
            使用 Google 進行登入
        </button>
        <!-- <div v-if="userData">
            <pre>{{ data }}</pre>
            <p></p>
            <pre>{{ userData }}</pre> Temporary debugging -->

        <!-- <p>Username: {{ userData.name }}</p>
            <p>Email: {{ userData.email }}</p> -->
        <!-- Add more user info as needed -->
        <!-- </div> -->
    </div>
</template>

<style scoped>
p {
    margin-top: 12px;
    word-break: break-all;
}
</style>
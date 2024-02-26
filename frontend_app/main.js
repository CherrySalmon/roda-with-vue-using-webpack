import { createApp } from "vue";
import App from './App.vue' //Our .vue startup file
import './static/global.css'      
import router from './router'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
// import vue3GoogleLogin from 'vue3-google-login'


const app = createApp(App)
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}
// app.use(vue3GoogleLogin, {
//   clientId: process.env.VUE_APP_GOOGLE_CLIENT_ID,
//   scope: 'profile email openid'
// })

app.use(router).mount('#app');

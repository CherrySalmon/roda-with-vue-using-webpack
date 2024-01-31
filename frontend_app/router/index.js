import { createRouter, createWebHistory } from 'vue-router';
import HomePage from '../pages/HomePage.vue';
import AboutPage from '../pages/AboutPage.vue';
import LoginPage from '../pages/LoginPage.vue';
import ManageAccount from '../pages/ManageAccount.vue';


const routes = [
  {
    path: '/home',
    name: 'Home',
    component: HomePage
  },
  {
    path: '/about',
    name: 'About',
    component: AboutPage
  },
  {
    path: '/login',
    name: 'Login',
    component: LoginPage
  },
  {
    path: '/manage-account',
    name: 'ManageAccount',
    component: ManageAccount
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router

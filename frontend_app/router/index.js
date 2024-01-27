// import { createRouter, createMemoryHistory, createWebHistory } from 'vue-router';
// import Home from '../pages/HomePage.vue';
// import About from '../pages/AboutPage.vue';


// const isServer = typeof window === 'undefined';
// const history = isServer ? createMemoryHistory() : createWebHistory();
// const routes = [
//   {
//     path: '/',
//     name: 'Home',
//     component: Home,
//   },
//   {
//     path: '/about',
//     name: 'About',
//     component: About,
//   },
// ];

// const router = createRouter({
//   history,
//   routes,
// });

// export default router;

import { createRouter, createWebHistory } from 'vue-router';
import HomePage from '../pages/HomePage.vue';
import AboutPage from '../pages/AboutPage.vue';
import LoginPage from '../pages/LoginPage.vue';


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
    path: '/',
    name: 'Login',
    component: LoginPage
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router

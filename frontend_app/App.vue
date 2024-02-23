<template>
  <div id="app">
    <el-row class="app-container">
      <el-col :span="6">
        <el-menu
          default-active="2"
          class="el-menu-vertical-demo"
          :collapse="isCollapse"
          @select="handleSelect"
        >
          <el-menu-item index="/manage-account">
            <el-icon><Avatar /></el-icon>
            <template #title>Account Management</template>
          </el-menu-item>
          <el-menu-item index="/manage-course">
            <el-icon><setting /></el-icon>
            <template #title>Course Management</template>
          </el-menu-item>
          <el-menu-item index="/course">
            <el-icon><document /></el-icon>
            <template #title>Course</template>
          </el-menu-item>
          <el-menu-item index="/login">
            <el-icon><document /></el-icon>
            <template #title>Login</template>
          </el-menu-item>
        </el-menu>
      </el-col>
      <el-col :span="18">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import Cookies from 'js-cookie';
// Debounce function to limit the rate at which a function is executed
const debounce = (callback, delay) => {
  let tid;
  return function (...args) {
    const ctx = this;
    if (tid) clearTimeout(tid);
    tid = setTimeout(() => {
      callback.apply(ctx, args);
    }, delay);
  };
};

// Saving the original ResizeObserver
const OriginalResizeObserver = window.ResizeObserver;

// Modifying ResizeObserver to use debounced callback
window.ResizeObserver = class ResizeObserver extends OriginalResizeObserver {
  constructor(callback) {
    super(debounce(callback, 20));
  }
};

export default {
    data() {
        return {

        };
    },

    methods: {
      handleSelect(key, keyPath) {
        console.log(key, keyPath)
        this.$router.push(key)
      },
      getUserFromCookie() {
        return Cookies.get('account_credential');
      },
      onLogout() {
          Cookies.remove('account_credential');
      }
    }
  }
</script>

<style>
#app {
  font-family: Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

</style>

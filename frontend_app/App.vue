<template>
  <div id="app">
    <el-container>
      <template v-if="account">
        <template v-if="account.roles.includes('admin')">
          <el-aside class="aside-container" :width="isCollapse?'60px':'300px'"></el-aside>
          <el-aside class="aside-container" :width="isCollapse?'60px':'300px'" style="position: fixed;">
            <el-menu
              default-active="/course"
              class="el-menu-vertical"
              :collapse="isCollapse"
              @select="handleSelect"
              background-color="#545c64"
              text-color="#fff"
              active-text-color="#ffd04b"
            >
              <el-menu-item @click="isCollapse = !isCollapse">
                <el-icon><component :is="isCollapse?'Expand':'Fold'" /></el-icon>
                <template #title>{{ isCollapse?'Expand Menu':'Collapse Menu' }}</template>
              </el-menu-item>
              <el-menu-item v-for="item in menuItems" :key="item.index" :index="item.index">
                <el-icon><component :is="item.icon" /></el-icon>
                <template #title>{{ item.title }}</template>
              </el-menu-item>
            </el-menu>
          </el-aside>
        </template>
      </template>
      
      <el-container class="app-container">
        <el-header height="80" style="background-color: #EFCD76;" class="noselect">
          <div class="icon-container">
            <img class="icon-img" src="./static/icon.png" width="50" height="50" @click="changeRoute('/course')"/>
            <span class="icon-text" @click="changeRoute('/course')">TYTO</span>
            <span class="avatar-name" v-if="!account.img == ''">{{ account.name }} - {{ account.roles.join(", ") }}</span>
            <template v-if="!account.img == ''">
              <el-popover
                trigger="hover"
                >
                <template #reference>
                  <el-avatar class="avatar-btn" :src="account.img"/>
                </template>
                <template #default>
                  <el-button class="logout-btn" @click="logout()" text>Logout</el-button>
                </template>
              </el-popover>
            </template>
          </div>
        </el-header>
        <el-container>
          <el-main>
            <router-view v-slot="{ Component }">
              <transition name="fade" mode="out-in">
                <component :is="Component" />
              </transition>
            </router-view>
          </el-main>
          <el-footer>© copyright Tyto Group</el-footer>
        </el-container>
      </el-container>
    </el-container>
  </div>
</template>

<script>
import cookieManager from './lib/cookieManager';
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
          isCollapse: true,
          menuItems: [
            { index: '/manage-account', icon: 'UserFilled', title: 'Account Management' },
            // { index: '/manage-course', icon: 'setting', title: 'Course Management' },
            { index: '/course', icon: 'document', title: 'Course' },
            { index: '/login', icon: '', title: 'Login' }, // only for test, to be delete before publish
          ],
          account: {
            roles: [],
            credential: '',
            img: ''
          }
        };
    },
    // beforeCreated() {
    //   if(!cookieManager.isLogout) {
    //     this.logout()
    //     if (window.location.pathname!='/login') {
    //       console.log(window.location.pathname)
    //       console.log(this.$route)
    //       this.$router.push({ path: '/login', query: { redirect: window.location.pathname } })
    //     }
    //   }
    // },
    created() {
      this.account = cookieManager.getAccount()
      if(!this.accountt) {
        this.logout()
        if (window.location.pathname!='/login') {
          console.log(window.location.pathname)
          console.log(this.$route)
          this.$router.push({ path: '/login', query: { redirect: window.location.pathname } })
        }
      }
    },
    watch: {
      $route(to, from) {
        if (from.name == 'Login' || to.name == 'Login') {
          this.account = cookieManager.getAccount()
        }
      }
    },
    methods: {
      handleSelect(key, keyPath) {
        this.$router.push(key)
      },
      changeRoute(route) {
        this.$router.push(route)
      },
      logout() {
        cookieManager.onLogout()
        this.$router.push('/login?redirect='+this.$route.fullPath)
      }
    }
  }
</script>

<style lang="css">
@import url('https://fonts.googleapis.com/css2?family=Asap:ital,wght@0,100..900;1,100..900&family=Noto+Sans:ital,wght@0,100..900;1,100..900&family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap');
#app {
  font-family: "Asap", 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', '微软雅黑', Arial, sans-serif;
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

.el-menu-vertical {
  height: 100vh;
}

.el-table--fit  {
  border-radius: 6px; -moz-border-radius: 6px; -webkit-border-radius: 6px;
}


.app-container {
  min-height: 100vh;
}
.aside-container {
  transition: 0.8s;
}

.icon-container {
  display: flex;
}

.icon-text {
  font-family: "Noto Sans", sans-serif;
  font-size: 2.5rem;
  font-weight: 900;
  line-height: 80px;
  font-style: italic;
  color: #fff;
  -webkit-text-fill-color: #EFCD76;
  -webkit-text-stroke: 3px #fff;
  cursor: pointer;
  transition: 0.8s;
}

.icon-img {
  margin: 15px;
  background-color:#EFCD76;
  border-radius: 50%;
  cursor: pointer;
}

.icon-text:hover{
  -webkit-filter: drop-shadow(3px 3px 3px #ffe8a472);
  filter: drop-shadow(3px 3px 3px #b6a77b72);
}
.avatar-btn {
  margin: 20px;
  cursor: pointer;
}
.avatar-btn:hover {
  -webkit-filter: drop-shadow(3px 3px 5px #ffcb47);
  filter: drop-shadow(3px 3px 5px #b8a671fa);
}
.logout-btn {
  width: 100%;
}
.avatar-name {
  color: #fff;
  font-weight: 900;
  line-height: 80px;
  margin-left: auto;
}
.noselect {
  -webkit-touch-callout: none; /* iOS Safari */
    -webkit-user-select: none; /* Safari */
     -khtml-user-select: none; /* Konqueror HTML */
       -moz-user-select: none; /* Old versions of Firefox */
        -ms-user-select: none; /* Internet Explorer/Edge */
            user-select: none; /* Non-prefixed version, currently
                                  supported by Chrome, Edge, Opera and Firefox */
}

.page-title {
  font-size: 3em;
  font-weight: 700;
  padding: 10px 10px 30px 10px;
}

</style>

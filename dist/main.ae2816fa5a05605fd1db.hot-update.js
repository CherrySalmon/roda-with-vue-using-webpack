"use strict";
/*
 * ATTENTION: The "eval" devtool has been used (maybe by default in mode: "development").
 * This devtool is neither made for production nor for readable output files.
 * It uses "eval()" calls to create a separate source file in the browser devtools.
 * If you are trying to read the output file, select a different devtool (https://webpack.js.org/configuration/devtool/)
 * or disable the default devtool with "devtool: false".
 * If you are looking for production-ready output files, see mode: "production" (https://webpack.js.org/configuration/mode/).
 */
self["webpackHotUpdateminimal_vue_webpack"]("main",{

/***/ "./node_modules/unplugin/dist/webpack/loaders/transform.js?unpluginName=unplugin-vue-components!./node_modules/unplugin/dist/webpack/loaders/transform.js?unpluginName=unplugin-auto-import!./node_modules/vue-loader/dist/index.js??ruleSet[1].rules[6].use[0]!./frontend_app/pages/course/components/ManagePeopleCard.vue?vue&type=script&lang=js":
/*!**********************************************************************************************************************************************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/unplugin/dist/webpack/loaders/transform.js?unpluginName=unplugin-vue-components!./node_modules/unplugin/dist/webpack/loaders/transform.js?unpluginName=unplugin-auto-import!./node_modules/vue-loader/dist/index.js??ruleSet[1].rules[6].use[0]!./frontend_app/pages/course/components/ManagePeopleCard.vue?vue&type=script&lang=js ***!
  \**********************************************************************************************************************************************************************************************************************************************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

eval("__webpack_require__.r(__webpack_exports__);\n/* harmony export */ __webpack_require__.d(__webpack_exports__, {\n/* harmony export */   \"default\": () => (__WEBPACK_DEFAULT_EXPORT__)\n/* harmony export */ });\n/* unplugin-vue-components disabled */\n/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ({\n  emits: ['dialog-closed', 'new-enrolls', 'update-enrollment', 'delete-enrollment'],\n  props: {\n    enrollments: {\n      type: Object,\n      default: () => ({})\n    },\n    currentRole: {\n      type: String\n    }\n  },\n  data() {\n    return {\n      localEnrollments: [],\n      newEnrollmentEmails: '',\n      newEnrolls: [],\n      enrollStep: 1,\n      peopleform: {\n        owner: ['owner', 'instructor', 'staff', 'student'],\n        instructor: ['staff', 'student'],\n        staff: ['student']\n      },\n      peopleRoleList: ['owner', 'instructor', 'staff', 'student'],\n      editDialogVisible: false,\n      selectedAccount: {}\n    }\n  },\n  watch: {\n    enrollments: {\n      deep: true,\n      handler(newVal) {\n        this.localEnrollments = newVal;\n      }\n    }\n  },\n  methods: {\n    updateEnroll(account) {\n      this.$emit('update-enrollment', account)\n      this.editDialogVisible = false;\n    },\n    openEditDialog(account) {\n      this.selectedAccount = JSON.parse(JSON.stringify(account))\n      \n      this.editDialogVisible = true;\n    },\n    checkIsModifable(role) {\n      const availableRoles = this.peopleform[this.currentRole]\n      return !availableRoles.includes(role)\n    },\n    onDialogClose() {\n      this.$emit('dialog-closed')\n    },\n    backStep() {\n      this.newEnrolls = []\n      this.enrollStep = 1\n    },\n    addEnrollments() {\n      this.$emit('new-enrolls', this.newEnrolls)\n      this.newEnrolls = []\n    },\n    handleEmailCreate() {\n      // Split the input by commas to support comma-separated emails\n      let emails\n      if(this.newEnrollmentEmails.indexOf(' ')>=0) {\n        emails = this.newEnrollmentEmails.split(' ');\n      }\n      else {\n        emails = this.newEnrollmentEmails.split(',');\n      }\n       \n      emails.forEach(email => {\n        if (email && !this.newEnrolls.some(user => user.email === email)) {\n          this.newEnrolls.push({ email: email, roles: 'student' });\n        }\n      })\n      this.newEnrollmentEmails = ''\n      this.enrollStep = 2\n    }\n  }\n});\n\n\n//# sourceURL=webpack://minimal-vue-webpack/./frontend_app/pages/course/components/ManagePeopleCard.vue?./node_modules/unplugin/dist/webpack/loaders/transform.js?unpluginName=unplugin-vue-components!./node_modules/unplugin/dist/webpack/loaders/transform.js?unpluginName=unplugin-auto-import!./node_modules/vue-loader/dist/index.js??ruleSet%5B1%5D.rules%5B6%5D.use%5B0%5D");

/***/ })

},
/******/ function(__webpack_require__) { // webpackRuntimeModules
/******/ /* webpack/runtime/getFullHash */
/******/ (() => {
/******/ 	__webpack_require__.h = () => ("f59ca14ae478393f1f17")
/******/ })();
/******/ 
/******/ }
);
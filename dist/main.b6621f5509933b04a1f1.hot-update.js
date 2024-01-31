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

/***/ "./node_modules/unplugin/dist/webpack/loaders/transform.js?unpluginName=unplugin-vue-components!./node_modules/unplugin/dist/webpack/loaders/transform.js?unpluginName=unplugin-auto-import!./node_modules/vue-loader/dist/index.js??ruleSet[1].rules[6].use[0]!./frontend_app/pages/ManageAccount.vue?vue&type=script&lang=js":
/*!*************************************************************************************************************************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/unplugin/dist/webpack/loaders/transform.js?unpluginName=unplugin-vue-components!./node_modules/unplugin/dist/webpack/loaders/transform.js?unpluginName=unplugin-auto-import!./node_modules/vue-loader/dist/index.js??ruleSet[1].rules[6].use[0]!./frontend_app/pages/ManageAccount.vue?vue&type=script&lang=js ***!
  \*************************************************************************************************************************************************************************************************************************************************************************************************************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

eval("__webpack_require__.r(__webpack_exports__);\n/* harmony export */ __webpack_require__.d(__webpack_exports__, {\n/* harmony export */   \"default\": () => (__WEBPACK_DEFAULT_EXPORT__)\n/* harmony export */ });\n/* harmony import */ var js_cookie__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! js-cookie */ \"./node_modules/js-cookie/dist/js.cookie.mjs\");\n/* harmony import */ var axios__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! axios */ \"./node_modules/axios/lib/axios.js\");\n/* unplugin-vue-components disabled */\n\n\n\n/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ({\n    data() {\n        return {\n            user_id: '',\n            accounts: [],\n            roleOptions: [\n                { label: 'Admin', value: 'admin' },\n                { label: 'Teacher', value: 'teacher' },\n                { label: 'Staff', value: 'staff' },\n                { label: 'Student', value: 'student' }\n            ],\n            editDialogVisible: false,\n            selectedAccount: {}\n        }\n    },\n    mounted() {\n        this.user_id = this.getUserFromCookie()\n        this.getUserRole(this.user_id)\n    },\n    methods: {\n        openEditDialog(account) {\n            this.selectedAccount = account\n            this.editDialogVisible = true\n        },\n        confirmEdit() {\n            this.updateAccount(this.selectedAccount)\n            this.editDialogVisible = false\n        },\n        async updateAccount(account) {\n            try {\n                account.account_id = this.user_id // for auth information\n                const response = await axios__WEBPACK_IMPORTED_MODULE_1__[\"default\"].put(`/api/account/${account.id}`, account)\n                if (response.status === 200) {\n                    this.getUserRole(this.user_id)\n                }\n            } catch (error) {\n                console.error('Error updating account', error)\n            }\n            this.showEditDialog = false\n        },\n        async deleteAccount(id) {\n            try {\n                const response = await axios__WEBPACK_IMPORTED_MODULE_1__[\"default\"].delete(`/api/account/${id}`, {\n                    account_id: this.user_id\n                })\n                if (response.status === 200) {\n                    this.getUserRole(this.user_id)\n                }\n            } catch (error) {\n                console.error('Error deleting account', error)\n            }\n        },\n        async getUserRole(account_id) {\n            const response = await axios__WEBPACK_IMPORTED_MODULE_1__[\"default\"].post('/api/account', {\n                account_id: account_id\n            })\n            if (response.status === 200) {\n                this.accounts = response.data.data\n            } else {\n                console.error('Error sending token to backend')\n            }\n        },\n        getUserFromCookie() {\n            return js_cookie__WEBPACK_IMPORTED_MODULE_0__[\"default\"].get('account')\n        }\n    }\n  });\n\n\n//# sourceURL=webpack://minimal-vue-webpack/./frontend_app/pages/ManageAccount.vue?./node_modules/unplugin/dist/webpack/loaders/transform.js?unpluginName=unplugin-vue-components!./node_modules/unplugin/dist/webpack/loaders/transform.js?unpluginName=unplugin-auto-import!./node_modules/vue-loader/dist/index.js??ruleSet%5B1%5D.rules%5B6%5D.use%5B0%5D");

/***/ })

},
/******/ function(__webpack_require__) { // webpackRuntimeModules
/******/ /* webpack/runtime/getFullHash */
/******/ (() => {
/******/ 	__webpack_require__.h = () => ("444b786ad68afccb7da6")
/******/ })();
/******/ 
/******/ }
);
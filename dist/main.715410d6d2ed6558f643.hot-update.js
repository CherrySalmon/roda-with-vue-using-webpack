/*
 * ATTENTION: The "eval" devtool has been used (maybe by default in mode: "development").
 * This devtool is neither made for production nor for readable output files.
 * It uses "eval()" calls to create a separate source file in the browser devtools.
 * If you are trying to read the output file, select a different devtool (https://webpack.js.org/configuration/devtool/)
 * or disable the default devtool with "devtool: false".
 * If you are looking for production-ready output files, see mode: "production" (https://webpack.js.org/configuration/mode/).
 */
self["webpackHotUpdateminimal_vue_webpack"]("main",{

/***/ "./frontend_app/router/index.js":
/*!**************************************!*\
  !*** ./frontend_app/router/index.js ***!
  \**************************************/
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

"use strict";
eval("__webpack_require__.r(__webpack_exports__);\n/* harmony export */ __webpack_require__.d(__webpack_exports__, {\n/* harmony export */   \"default\": () => (__WEBPACK_DEFAULT_EXPORT__)\n/* harmony export */ });\n/* harmony import */ var vue_router__WEBPACK_IMPORTED_MODULE_12__ = __webpack_require__(/*! vue-router */ \"./node_modules/vue-router/dist/vue-router.mjs\");\n/* harmony import */ var _pages_Login_vue__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../pages/Login.vue */ \"./frontend_app/pages/Login.vue\");\n/* harmony import */ var _pages_ManageAccount_vue__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../pages/ManageAccount.vue */ \"./frontend_app/pages/ManageAccount.vue\");\n/* harmony import */ var _pages_course_index_vue__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../pages/course/index.vue */ \"./frontend_app/pages/course/index.vue\");\n/* harmony import */ var _pages_course_AllCourse_vue__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../pages/course/AllCourse.vue */ \"./frontend_app/pages/course/AllCourse.vue\");\n/* harmony import */ var _pages_course_SingleCourse_vue__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../pages/course/SingleCourse.vue */ \"./frontend_app/pages/course/SingleCourse.vue\");\n/* harmony import */ var _pages_ManageCourse_vue__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../pages/ManageCourse.vue */ \"./frontend_app/pages/ManageCourse.vue\");\n/* harmony import */ var _pages_404_vue__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ../pages/404.vue */ \"./frontend_app/pages/404.vue\");\n/* harmony import */ var _pages_course_AttendanceTrack_vue__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ../pages/course/AttendanceTrack.vue */ \"./frontend_app/pages/course/AttendanceTrack.vue\");\n/* harmony import */ var _pages_course_components_AttendanceEventCard_vue__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ../pages/course/components/AttendanceEventCard.vue */ \"./frontend_app/pages/course/components/AttendanceEventCard.vue\");\n/* harmony import */ var _pages_course_components_AssignmentCard_vue__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! ../pages/course/components/AssignmentCard.vue */ \"./frontend_app/pages/course/components/AssignmentCard.vue\");\n/* harmony import */ var _pages_course_components_AssignmentCard_vue__WEBPACK_IMPORTED_MODULE_9___default = /*#__PURE__*/__webpack_require__.n(_pages_course_components_AssignmentCard_vue__WEBPACK_IMPORTED_MODULE_9__);\n/* harmony import */ var _pages_course_components_LocationCard_vue__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(/*! ../pages/course/components/LocationCard.vue */ \"./frontend_app/pages/course/components/LocationCard.vue\");\n/* harmony import */ var _pages_course_components_ManagePeopleCard_vue__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(/*! ../pages/course/components/ManagePeopleCard.vue */ \"./frontend_app/pages/course/components/ManagePeopleCard.vue\");\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nconst routes = [\n  {\n    path: \"/\",\n    component: _pages_course_AllCourse_vue__WEBPACK_IMPORTED_MODULE_3__[\"default\"],\n  },\n  {\n    path: '/login',\n    name: 'Login',\n    component: _pages_Login_vue__WEBPACK_IMPORTED_MODULE_0__[\"default\"]\n  },\n  {\n    path: '/course',\n    name: 'Course',\n    component: _pages_course_index_vue__WEBPACK_IMPORTED_MODULE_2__[\"default\"],\n    children: [\n      {\n        path: '',\n        name: 'Courses',\n        component: _pages_course_AllCourse_vue__WEBPACK_IMPORTED_MODULE_3__[\"default\"],\n      },\n      {\n        path: ':id',\n        name: 'SingleCourse',\n        component: _pages_course_SingleCourse_vue__WEBPACK_IMPORTED_MODULE_4__[\"default\"],\n        children: [\n          {\n            path: 'attendance',\n            name: 'AttendanceEventCard',\n            component: _pages_course_components_AttendanceEventCard_vue__WEBPACK_IMPORTED_MODULE_8__[\"default\"]\n          },\n          {\n            path: 'assignment',\n            name: 'AssignmentCard',\n            component: (_pages_course_components_AssignmentCard_vue__WEBPACK_IMPORTED_MODULE_9___default())\n          },\n          {\n            path: 'location',\n            name: 'LocationCard',\n            component: _pages_course_components_LocationCard_vue__WEBPACK_IMPORTED_MODULE_10__[\"default\"]\n          },\n          {\n            path: 'people',\n            name: 'ManagePeopleCard',\n            component: _pages_course_components_ManagePeopleCard_vue__WEBPACK_IMPORTED_MODULE_11__[\"default\"]\n          }\n        ]\n      },\n      // {\n      //   path: ':id/attendance',\n      //   name: 'AttendanceTrack',\n      //   component: AttendanceTrack\n      // },\n    ]\n  },\n  {\n    path: '/manage-account',\n    name: 'ManageAccount',\n    component: _pages_ManageAccount_vue__WEBPACK_IMPORTED_MODULE_1__[\"default\"]\n  },\n  {\n    path: '/manage-course',\n    name: 'ManageCourse',\n    component: _pages_ManageCourse_vue__WEBPACK_IMPORTED_MODULE_5__[\"default\"]\n  },\n  {\n    path: \"/:notFound\",\n    component: _pages_404_vue__WEBPACK_IMPORTED_MODULE_6__[\"default\"],\n  }\n]\n\nconst router = (0,vue_router__WEBPACK_IMPORTED_MODULE_12__.createRouter)({\n  history: (0,vue_router__WEBPACK_IMPORTED_MODULE_12__.createWebHistory)(),\n  routes\n})\n\n/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = (router);\n\n\n//# sourceURL=webpack://minimal-vue-webpack/./frontend_app/router/index.js?");

/***/ }),

/***/ "./frontend_app/pages/course/components/AssignmentCard.vue":
/*!*****************************************************************!*\
  !*** ./frontend_app/pages/course/components/AssignmentCard.vue ***!
  \*****************************************************************/
/***/ (() => {

eval("/* unplugin-vue-components disabled */\n\n//# sourceURL=webpack://minimal-vue-webpack/./frontend_app/pages/course/components/AssignmentCard.vue?");

/***/ })

},
/******/ function(__webpack_require__) { // webpackRuntimeModules
/******/ /* webpack/runtime/getFullHash */
/******/ (() => {
/******/ 	__webpack_require__.h = () => ("eaeea8ba425dee2cbb77")
/******/ })();
/******/ 
/******/ }
);
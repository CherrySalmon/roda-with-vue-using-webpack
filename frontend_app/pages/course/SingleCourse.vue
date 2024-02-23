<template>
  <div class="single-course-container">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>{{ course.name }}</span>
      </div>
      <div>
        <p>Semester: {{ course.semester }}</p>
        <p>Start Time: {{ course.start_time || 'N/A' }}</p>
        <p>Duration: {{ course.duration ? course.duration + ' hours' : 'N/A' }}</p>
        <p>Repeat: {{ course.repeat || 'N/A' }}</p>
        <p>Occurrence: {{ course.occurrence || 'N/A' }}</p>
      </div>
    </el-card>
    <div v-if="['owner', 'instructor', 'staff'].includes(course.enroll_identity)">
      <el-button type="primary" @click="showModifyCourseDialog = true">Modify Course</el-button>
      <el-button type="primary" @click="openPeopleManager()">Manage People</el-button>
      <!-- Manage Attendance Button can be added similarly -->
    </div>

    <!-- Modify Course Dialog -->
    <el-dialog title="Modify Course" v-model="showModifyCourseDialog">
      <!-- Form for modifying course. Bind inputs to course properties and on confirm, call an API to update. -->
    </el-dialog>

    <!-- Manage People Dialog -->
    <el-dialog title="Manage People" v-model="showManagePeopleDialog" width="50%">
      <div>
        <el-input
          v-model="newEnrollmentEmails"
          placeholder="Enter email addresses (comma-separated)"
          class="input-with-select">
        </el-input>
        <el-button @click="addEnrollments">Add</el-button>
      </div>
      <div>{{ enrollments }}</div>
      <el-table :data="enrollments" style="width: 100%">
        <el-table-column prop="email" label="Email"></el-table-column>
        
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';
import cookieManager from '../../lib/cookieManager';

export default {
  name: 'SingleCourse',

  data() {
    return {
      course: {},
      accountRoles: [],
      accountCredential: '',
      showModifyCourseDialog: false,
      showManagePeopleDialog: false,
      enrollments: [],
      newEnrollmentEmails: ''
    };
  },

  created() {
    this.accountRoles = cookieManager.getCookie('account_roles') ? cookieManager.getCookie('account_roles').split(',') : [];
    this.accountCredential = cookieManager.getCookie('account_credential');
    this.course.id = this.$route.params.id;
    this.fetchCourse(this.course.id);
  },

  methods: {
    fetchCourse(id) {
      axios.get(`/api/course/${id}`, {
          headers: {
              Authorization: `Bearer ${this.accountCredential}`,
          },
      }).then(response => {
          this.course = response.data.data;
      }).catch(error => {
          console.error('Error fetching course:', error);
      });
    },
    openPeopleManager() {
        this.showManagePeopleDialog = true
        this.fetchEnrollments
    },
    fetchEnrollments() {
      axios.get(`/api/course/${this.course.id}/enroll`, {
        headers: {
          Authorization: `Bearer ${this.accountCredential}`,
        }
      }).then(response => {
        this.enrollments = response.data.data;
        console.log(this.enrollments)
      }).catch(error => {
        console.error('Error fetching enrollments:', error);
      });
    },

    addEnrollments() {
      // Split newEnrollmentEmails by comma, send API request to add new enrollments
      // On success, fetchEnrollments again to refresh the list
    },

    updateEnrollment(enrollment) {
      // Call API to update enrollment based on changed role
      // On success, you may choose to fetchEnrollments again or simply update the UI directly
    }
  },
};
</script>

<style scoped>
/* Add your styles here */
</style>
``

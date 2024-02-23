<template>
    <div>
      <el-button v-if="accountRoles.includes('teacher')" @click="showCreateCourseDialog = true">Create Course</el-button>
      <el-dialog title="Create Course" v-model="showCreateCourseDialog">
        <el-form ref="createCourseForm" :model="createCourseForm" label-width="120px">
          <el-form-item label="Name">
            <el-input v-model="createCourseForm.name"></el-input>
          </el-form-item>
          <el-form-item label="Semester">
            <el-input v-model="createCourseForm.semester"></el-input>
          </el-form-item>
          <el-form-item label="Start Time">
            <el-date-picker v-model="createCourseForm.start_time" type="datetime" placeholder="Select start time"></el-date-picker>
          </el-form-item>
          <el-form-item label="Duration (hours)">
            <el-input-number v-model="createCourseForm.duration" :min="1"></el-input-number>
          </el-form-item>
          <el-form-item label="Repeat">
            <el-select v-model="createCourseForm.repeat" placeholder="Select">
              <el-option label="Do not repeat" value="no-repeat"></el-option>
              <el-option label="Weekly" value="weekly"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item v-show="createCourseForm.repeat!='no-repeat'" label="Repeat">
            <el-input-number v-model="createCourseForm.occurrence" :step="1" step-strictly ></el-input-number>
          </el-form-item>
          <el-form-item label="Logo">
            <el-input v-model="createCourseForm.logo"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="showCreateCourseDialog = false">Cancel</el-button>
          <el-button type="primary" @click="createCourse">Confirm</el-button>
        </span>
      </el-dialog>

      <el-card v-for="course in courses" :key="course.id" class="course-item" shadow="hover" @click="changeRoute('/course/'+course.id)">
        <img
          :src="course.icon"
          class="image"
        />
        <div style="padding: 14px">
            <h3>{{ course.name }}</h3>
         <p>Semester: {{ course.semester }}</p>
        </div>
      </el-card>
    </div>
  </template>
  
<script>
  import axios from 'axios';
  import cookieManager from '../../lib/cookieManager';

  
  export default {
    name: 'Courses',
  
    data() {
      return {
        courses: [],
        accountRoles: [],
        accountCredential: '',
        showCreateCourseDialog: false,
        createCourseForm: {
          name: '',
          semester: '',
          start_time: '',
          duration: 1,
          repeat: '',
          occurrence: 1,
          logo: '',
        },
      };
    },
    created() {
        this.accountRoles = cookieManager.getCookie('account_roles') ? cookieManager.getCookie('account_roles').split(',') : [];
        this.accountCredential = cookieManager.getCookie('account_credential');
        this.fetchCourses();
    },
    methods: {
        changeRoute(route) {
            this.$router.push(route)
        },
        fetchCourses() {
            axios.get('api/course', {
            headers: {
                Authorization: `Bearer ${this.accountCredential}`,
            },
            }).then(response => {
            this.courses = response.data.data;
            }).catch(error => {
            console.error('Error fetching courses:', error);
            });
        },
        createCourse() {
            if (this.createCourseForm.repeat == 'no-repeat') {
                this.createCourseForm.occurrence = 1
            }

            axios.post('api/course', this.createCourseForm, {
            headers: {
                Authorization: `Bearer ${this.accountCredential}`,
            },
            }).then(() => {
            this.showCreateCourseDialog = false;
            this.fetchCourses(); // Refresh the list after adding
            }).catch(error => {
            console.error('Error creating course:', error);
            });
        },
        },
    };
</script>
  
<style scoped>
p {
    margin-top: 12px;
    word-break: break-all;
}
.course-item {
    border-bottom: 1px solid #eee;
    padding: 20px 0;
    width: 300px;
    margin: 20px;
    cursor: pointer;
}
</style>
  
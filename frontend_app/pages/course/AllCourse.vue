<template>
  <div>
    <div style="margin: 40px">
      <h2>Welcome Back, {{account.name}}!</h2>
      <p>We're thrilled to have you back! As {{ account.roles.join(' & ') }}, you have access to features including {{ getFeatures(account.roles) }}.</p>
    </div>
    <div class="page-title">Courses</div>
    <template v-if="account">
      <el-button v-if="account.roles.includes('creator')" @click="showCreateCourseDialog = true" color="#824533"
        :dark="true">Start a New Course</el-button>
    </template>
    <el-dialog title="Create Course" v-model="showCreateCourseDialog">
      <el-form ref="createCourseForm" :model="createCourseForm" label-width="120px" :rules="rules" :status-icon="true">
        <el-form-item label="Name" prop="name">
          <el-input v-model="createCourseForm.name"></el-input>
        </el-form-item>
        <el-form-item label="Start Time">
          <el-date-picker v-model="createCourseForm.start_time" type="datetime"
            placeholder="Select start time"></el-date-picker>
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
        <el-form-item v-show="createCourseForm.repeat != 'no-repeat'" label="Repeat">
          <el-input-number v-model="createCourseForm.occurrence" :step="1" step-strictly></el-input-number>
        </el-form-item>
        <el-form-item label="Logo">
          <el-input v-model="createCourseForm.logo"></el-input>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="closeForm('createCourseForm')">Cancel</el-button>
        <el-button type="primary" @click="submitForm('createCourseForm')">Confirm</el-button>
      </span>
    </el-dialog>

    <div class="course-container">
      <template v-for="course in courses" :key="course.id">
        <el-card class="course-item" shadow="hover">
          <div @click="changeRoute('/course/' + course.id)">
            <img :src="course.icon" class="image" />
            <div style="padding: 14px">
              <h3>{{ course.name }}</h3>
            </div>
          </div>
          <div v-if="account.roles.includes('creator')" class="course-option-container" @click="deleteCourse(course.id)">
            <el-icon><Delete /></el-icon>
          </div>
        </el-card>
      </template>
    </div>
  </div>
</template>
  
<script>
import axios from 'axios';
import cookieManager from '../../lib/cookieManager';
import { ElNotification } from 'element-plus'

export default {
  name: 'Courses',

  data() {
    return {
      rules: {
        name: [
          { required: true, message: 'Please input course name', trigger: 'blur' }
        ]
      },
      features: {
        admin: 'manage accounts',
        creator: 'create courses',
        member: 'mark attendance'
      },
      courses: [],
      account: {
        roles: [],
        credential: ''
      },
      showCreateCourseDialog: false,
      createCourseForm: {
        name: '',
        start_time: '',
        duration: 1,
        repeat: '',
        occurrence: 1,
        logo: '',
      },
    };
  },
  created() {
    this.account = cookieManager.getAccount()
    if (this.account) {
      this.fetchCourses()
    }
  },
  methods: {
    getFeatures(roles) {
      let features = roles.map((role) => {
        return this.features[role]
      })
      return features.join(', ')
    },
    changeRoute(route) {
      this.$router.push(route)
    },
    deleteCourse(course_id) {
      axios.delete('api/course/'+course_id, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        },
      }).then(response => {
        ElNotification({
          title: 'Success',
          message: 'Delete success!',
          type: 'success',
        })
        this.fetchCourses()
      }).catch(error => {
        console.error('Error fetching courses:', error);
        ElNotification({
          title: 'Error',
          message: error.message,
          type: 'error',
        })
      });
    },
    fetchCourses() {
      axios.get('api/course', {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        },
      }).then(response => {
        this.courses = response.data.data;
      }).catch(error => {
        console.error('Error fetching courses:', error);
      });
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.createCourse()
        } else {
          return false;
        }
      });
    },
    resetForm(formName) {
      this.$refs[formName].resetFields();
    },
    closeForm(formName) {
      this.$refs[formName].resetFields();
      this.showCreateCourseDialog = false;
    },
    createCourse() {
      if (this.createCourseForm.repeat == 'no-repeat') {
        this.createCourseForm.occurrence = 1
      }

      axios.post('api/course', this.createCourseForm, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
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
  width: 270px;
  margin: 20px;
  cursor: pointer;
}

.course-container {
  display: flex;
  justify-content: left;
  width: 90%;
  margin: 30px auto;
  flex-wrap: wrap;
}
.course-option-container {
  background-color: #f56c6c;
  width: 35px;
  height: 35px;
  color: #fff;
  padding: 9px 10px;
  border-radius: 50%;
  cursor: pointer;
  float: right;
}
</style>
  
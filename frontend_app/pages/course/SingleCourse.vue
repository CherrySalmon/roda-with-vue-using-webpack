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
    <div v-if="course.enroll_identity">
        <div v-if="course.enroll_identity != 'student'">
            <el-button type="primary" @click="showModifyCourseDialog = true">Modify Course</el-button>
            <el-button type="primary" @click="openPeopleManager()">Manage People</el-button>
        </div>
    </div>

    <!-- Modify Course Dialog -->
    <el-dialog title="Modify Course" v-model="showModifyCourseDialog">
        <el-form ref="course" :model="courseForm" label-width="120px">
          <el-form-item label="Name">
            <el-input v-model="courseForm.name"></el-input>
          </el-form-item>
          <el-form-item label="Semester">
            <el-input v-model="courseForm.semester"></el-input>
          </el-form-item>
          <el-form-item label="Start Time">
            <el-date-picker v-model="courseForm.start_time" type="datetime" placeholder="Select start time"></el-date-picker>
          </el-form-item>
          <el-form-item label="Duration (hours)">
            <el-input-number v-model="courseForm.duration" :min="1"></el-input-number>
          </el-form-item>
          <el-form-item label="Repeat">
            <el-select v-model="courseForm.repeat" placeholder="Select">
              <el-option label="Do not repeat" value="no-repeat"></el-option>
              <el-option label="Weekly" value="weekly"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item v-show="courseForm.repeat!='no-repeat'" label="Repeat">
            <el-input-number v-model="courseForm.occurrence" :step="1" step-strictly ></el-input-number>
          </el-form-item>
          <el-form-item label="Logo">
            <el-input v-model="courseForm.logo"></el-input>
          </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
          <el-button @click="showModifyCourseDialog = false">Cancel</el-button>
          <el-button type="primary" @click="updateCourse">Confirm</el-button>
        </span>
    </el-dialog>

    <!-- Manage People Dialog -->
    <el-dialog title="Manage People" v-model="showManagePeopleDialog" width="50%">
      <div>
        <el-input
          v-model="newEnrollmentEmails"
          placeholder="Enter email addresses (space-separated)"
          class="input-with-select"
          @keyup.enter="handleEmailCreate()">
        </el-input>
        <el-button @click="handleEmailCreate()">Add Account</el-button>
        <div>New enroll:</div>
        <div v-for="enroll in newEnrolls" :key="enroll">{{ enroll }}</div>
        <el-button @click="addEnrollments">Enroll Course</el-button>
      </div>
      
      <el-table style="width: 100%" :data="enrollments">
        <el-table-column type="index" width="50" />
        <el-table-column width="70">
            <template #default="scope">
                <el-avatar shape="square" :size="40" :src="scope.row.avatar" />
            </template>
        </el-table-column>
        <el-table-column prop="name" label="Name" width="180" />
        <el-table-column prop="email" label="Email" />
        <el-table-column label="Role">
          <template #default="scope" >
            <el-select v-model="scope.row.enrolls" placeholder="Select role" @change="updateEnrollment(scope.row)" multiple :disabled="scope.row.enrolls.includes('owner')">
              <el-option label="Instructor" value="instructor"></el-option>
              <el-option label="Staff" value="staff"></el-option>
              <el-option label="Student" value="student"></el-option>
            </el-select>
          </template>
        </el-table-column>
        <el-table-column label="Operations" width="180">
            <template #default="scope">
                <el-button type="danger" @click="deleteEnrollments(scope.row.id)" size="small">Delete</el-button>
            </template>
        </el-table-column>
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
      course: {
      },
      courseForm: {
      },
      accountRoles: [],
      accountCredential: '',
      showModifyCourseDialog: false,
      showManagePeopleDialog: false,
      enrollments: [],
      newEnrolls: [],
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
            // Copying the course object to courseForm
            this.courseForm = {...this.course};

            // Deleting the id and enroll_identity keys from courseForm
            delete this.courseForm.id;
            delete this.courseForm.enroll_identity;
        }).catch(error => {
            console.error('Error fetching course:', error);
        });
        },
    updateCourse() {
        if (this.courseForm.repeat == 'no-repeat') {
                this.courseForm.occurrence = 1
            }

            axios.put('api/course/'+this.course.id, this.courseForm, {
            headers: {
                Authorization: `Bearer ${this.accountCredential}`,
            },
            }).then(() => {
            this.showModifyCourseDialog = false;
            this.fetchCourse(this.course.id);
            }).catch(error => {
            console.error('Error creating course:', error);
        });
    },
    handleEmailCreate() {
        // Split the input by commas to support comma-separated emails
        let emails = this.newEnrollmentEmails.split(' ');
        emails.forEach(email => {
            if (email && !this.newEnrolls.some(user => user.email === email)) {
            this.newEnrolls.push({email: email, roles: 'student'});
            }
        })
        this.newEnrollmentEmails = ''
    },
    openPeopleManager() {
        this.showManagePeopleDialog = true
        this.fetchEnrollments()
    },
    fetchEnrollments() {
      axios.get(`/api/course/${this.course.id}/enroll`, {
        headers: {
          Authorization: `Bearer ${this.accountCredential}`,
        }
      }).then(response => {
        this.enrollments = response.data.data;
        this.enrollments.forEach((enrollment) => {
            enrollment.enrolls = enrollment.enroll_identity.split(',')
        });
        
      }).catch(error => {
        console.error('Error fetching enrollments:', error);
      });
    },

    addEnrollments() {
        axios.post(`/api/course/${this.course.id}/enroll`, {enroll: this.newEnrolls}, {
        headers: {
          Authorization: `Bearer ${this.accountCredential}`,
        }
        }).then(response => {
            console.log(response)
            this.fetchEnrollments()
        }).catch(error => {
            console.error('Error fetching enrollments:', error);
        });
    },

    updateEnrollment(enrollment) {
        let entollList = {
          enroll:  [{
            email: enrollment.email,
            roles: enrollment.enrolls.join(',')
        }]}
        axios.post(`/api/course/${this.course.id}/enroll`, entollList, {
        headers: {
          Authorization: `Bearer ${this.accountCredential}`,
        }
      }).then(response => {
        console.log(response)
      }).catch(error => {
        console.error('Error fetching enrollments:', error);
      });
    },

    deleteEnrollments(enrollment) {
        axios.delete(`/api/course/${this.course.id}/enroll/${enrollment}`, {
        headers: {
          Authorization: `Bearer ${this.accountCredential}`,
        }
      }).then(response => {
        console.log(response)
        this.fetchEnrollments()
      }).catch(error => {
        console.error('Error fetching enrollments:', error);
      });
    }
  },
};
</script>

<style scoped>
/* Add your styles here */
</style>
``

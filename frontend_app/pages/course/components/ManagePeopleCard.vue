<template>
  <div class="people-card-container">
    <h1 class="people-title">Add new student</h1>
    <div class="input-email-container">
      <div style="height: 100px">
        <el-steps direction="vertical" :active="enrollStep">
          <el-step title="Step 1" :icon="Edit" />
          <el-step title="Step 2" :icon="Upload" />
        </el-steps>
      </div>
      <div v-if="enrollStep == 1" class="input-email-item">
        <el-input v-model="newEnrollmentEmails" placeholder="Enter email addresses (space-separated)"
          style="width: 70%; height: 40px;" @keyup.enter="handleEmailCreate()">
        </el-input>
        <el-button @click="handleEmailCreate()" text type="primary">Add Accounts</el-button>
      </div>
      <div v-if="enrollStep == 2" class="input-email-item">
        <div>New enroll:</div>
        <div class="new-email-box">
          <div v-for="enroll in newEnrolls" :key="enroll">{{ enroll.email }}</div>
        </div>
        <el-button @click="backStep">Back</el-button>
        <el-button @click="addEnrollments" type="primary">Enroll in Course</el-button>
      </div>
    </div>


    <h1 class="people-title">Manage People</h1>


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
        <template #default="scope">
          <el-select v-model="scope.row.enrolls" placeholder="Select role" @change="$emit('update-enrollment', scope.row)"
            multiple :disabled="scope.row.enrolls.includes('owner')">
            <el-option label="Instructor" value="instructor"></el-option>
            <el-option label="Staff" value="staff"></el-option>
            <el-option label="Student" value="student"></el-option>
          </el-select>
        </template>
      </el-table-column>
      <el-table-column label="Operations" width="180">
        <template #default="scope">
          <el-button type="danger" @click="$emit('delete-enrollment', scope.row.account_id)"
            size="small">Delete</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>
  
<script>
export default {
  emits: ['dialog-closed', 'new-enrolls', 'update-enrollment', 'delete-enrollment'],
  props: {
    enrollments: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      localEnrollments: [],
      newEnrollmentEmails: '',
      newEnrolls: [],
      enrollStep: 1
    }
  },
  watch: {
    enrollments: {
      deep: true,
      handler(newVal) {
        this.localEnrollments = newVal;
      }
    }
  },
  methods: {
    onDialogClose() {
      this.$emit('dialog-closed')
    },
    backStep() {
      this.newEnrolls = []
      this.enrollStep = 1
    },
    addEnrollments() {
      this.$emit('new-enrolls', this.newEnrolls)
      this.newEnrolls = []
    },
    handleEmailCreate() {
      // Split the input by commas to support comma-separated emails
      let emails = this.newEnrollmentEmails.split(' ');
      emails.forEach(email => {
        if (email && !this.newEnrolls.some(user => user.email === email)) {
          this.newEnrolls.push({ email: email, roles: 'student' });
        }
      })
      this.newEnrollmentEmails = ''
      this.enrollStep = 2
    }
  }
}
</script>

<style>
.people-card-container {
  margin: 20px 40px;
}

.input-email-container {
  text-align: left;
  padding: 10px 40px 30px 40px;
  display: flex;
  justify-content: left;

  flex-wrap: wrap;
}

.input-email-item {
  margin: 0px 40px;
  width: 80%;
}

.new-email-box {
  background-color: #fff;
  overflow: scroll;
  width: 70%;
  height: 100px;
  margin: 10px 0;
}

.people-title {
  margin: 30px 0 20px 0;
}</style>
  
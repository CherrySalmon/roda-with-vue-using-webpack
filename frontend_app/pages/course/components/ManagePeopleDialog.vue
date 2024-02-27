<template>
    <el-dialog title="Manage People" v-model="showManagePeopleDialog" width="50%" @close="onDialogClose">
      <div class="input-email-container">
        <el-input v-model="newEnrollmentEmails" placeholder="Enter email addresses (space-separated)"
          style="width: 80%;" @keyup.enter="handleEmailCreate()">
        </el-input>
        <el-button @click="handleEmailCreate()" text type="primary">Add Account</el-button>
        <div class="input-email-item">New enroll:
            <div v-for="enroll in newEnrolls" :key="enroll">{{ enroll.email }}</div>
        </div>
        
        <el-button @click="addEnrollments" class="input-email-item" type="primary">Enroll Course</el-button>
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
            <el-button type="danger" @click="$emit('delete-enrollment', scope.row.account_id)" size="small">Delete</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>
</template>
  
  <script>
  export default {
    emits: ['dialog-closed', 'new-enrolls','update-enrollment','delete-enrollment'],
    props: {
      enrollments: {
        type: Object,
        default: () => ({})
      },
      visible: Boolean
    },
    data() {
        return {
            showManagePeopleDialog: false,
            localEnrollments: [],
            newEnrollmentEmails: '',
            newEnrolls: []
        }
    },
    watch: {
        enrollments: {
            deep: true,
            handler(newVal) {
                this.localEnrollments = newVal;
        }
      },
      visible: {
        handler(newVal) {
            this.showManagePeopleDialog = newVal
        }
      }
    },
    methods: {
        onDialogClose() {
            this.$emit('dialog-closed')
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
        }
    }
}
</script>

<style>
.input-email-container {
    text-align: left;
    padding: 10px 40px 30px 40px;
    display: flex;
    justify-content: space-around;
    flex-wrap: wrap;
}
.input-email-item {
    margin: 20px 0;
}
</style>
  
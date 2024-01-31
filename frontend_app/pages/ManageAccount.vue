<template>
  <div class="page-container">
    <el-table style="width: 100%" :data="accounts">
        <el-table-column type="index" width="50" />
        <el-table-column prop="name" label="Name" width="180" />
        <el-table-column prop="email" label="Email" />
        <el-table-column prop="role" label="Role" />
        <el-table-column prop="permissions" label="Permissions" />
        <el-table-column label="Operations" width="180">
            <template #default="scope">
                <el-button @click="openEditDialog(scope.row)" size="small">Edit</el-button>
                <el-button type="danger" @click="deleteAccount(scope.row.id)" size="small">Delete</el-button>
            </template>
        </el-table-column>
    </el-table>
    <el-dialog title="Edit Account" v-model="editDialogVisible">
      <el-form :model="selectedAccount" label-width="80px">
        <el-form-item label="Email">
          <el-input v-model="selectedAccount.email" autocomplete="off"></el-input>
        </el-form-item>
        <el-form-item label="Role">
          <el-select v-model="selectedAccount.role" placeholder="Please select a role">
            <el-option
              v-for="option in roleOptions"
              :key="option.value"
              :label="option.label"
              :value="option.value">
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="editDialogVisible = false">Cancel</el-button>
        <el-button type="primary" @click="confirmEdit">Confirm</el-button>
      </span>
    </el-dialog>
  </div>
</template>


<script>
import Cookies from 'js-cookie'
import axios from 'axios'

export default {
    data() {
        return {
            user_id: '',
            accounts: [],
            roleOptions: [
                { label: 'Admin', value: 'admin' },
                { label: 'Teacher', value: 'teacher' },
                { label: 'Staff', value: 'staff' },
                { label: 'Student', value: 'student' }
            ],
            editDialogVisible: false,
            selectedAccount: {}
        }
    },
    mounted() {
        this.user_id = this.getUserFromCookie()
        this.getUserRole(this.user_id)
    },
    methods: {
        openEditDialog(account) {
            this.selectedAccount = account
            this.editDialogVisible = true
        },
        confirmEdit() {
            this.updateAccount(this.selectedAccount)
            this.editDialogVisible = false
        },
        async updateAccount(account) {
            try {
                account.account_id = this.user_id // for auth information
                const response = await axios.put(`/api/account/${account.id}`, account)
                if (response.status === 200) {
                    this.getUserRole(this.user_id)
                }
            } catch (error) {
                console.error('Error updating account', error)
            }
            this.showEditDialog = false
        },
        async deleteAccount(id) {
            try {
                const response = await axios.delete(`/api/account/${id}`, {
                    account_id: this.user_id
                })
                if (response.status === 200) {
                    this.getUserRole(this.user_id)
                }
            } catch (error) {
                console.error('Error deleting account', error)
            }
        },
        async getUserRole(account_id) {
            const response = await axios.post('/api/account', {
                account_id: account_id
            })
            if (response.status === 200) {
                this.accounts = response.data.data
            } else {
                console.error('Error sending token to backend')
            }
        },
        getUserFromCookie() {
            return Cookies.get('account')
        }
    }
  }
</script>

<style scoped>
.page-container {
    width: 80%;
    margin: auto;
}
</style>

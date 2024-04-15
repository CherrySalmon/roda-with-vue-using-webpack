<template>
  <el-dialog
    :title="dialogTitle"
    v-model="showAssignmentDialog"
    @close="onDialogClose"
    width="100%"
    style="max-width: 960px;"
    :modal-append-to-body="false"
  >
    <el-form ref="assignmentForm" :model="assignmentForm" label-width="auto">
      <el-form-item label="Name">
        <el-input v-model="assignmentForm.name" style="width:95%;"></el-input>
      </el-form-item>
      <el-form-item label="Description">
        <el-input
          type="textarea"
          v-model="assignmentForm.description"
          style="width:95%;"
        ></el-input>
      </el-form-item>
      <el-form-item label="Due Date">
        <el-date-picker
          v-model="assignmentForm.due_at"
          type="datetime"
          placeholder="Select due date"
          style="width:95%;"
          :default-time="defaultDueTime"
        ></el-date-picker>
      </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button @click="onDialogClose">Cancel</el-button>
      <el-button type="primary" @click="submitForm">Confirm</el-button>
    </span>
  </el-dialog>
</template>

<script>
export default {
  emits: ['dialog-closed', 'create-assignment', 'update-assignment'],
  props: {
    assignmentData: {
      type: Object,
      default: () => ({})
    },
    visible: Boolean
  },
  data() {
    return {
      showAssignmentDialog: false,
      assignmentForm: {
        name: '',
        description: '',
        due_at: ''
      }
    };
  },
  computed: {
    dialogTitle() {
      return this.assignmentData.id ? 'Update Assignment' : 'Create Assignment';
    },
    defaultDueTime() {
        let dueTime = new Date();
        dueTime.setHours(23, 59, 0, 0);
        return dueTime;
    }
  },
  created() {
    this.showAssignmentDialog = this.visible
  },
  watch: {
    visible: function (newVal) {
      this.showAssignmentDialog = newVal;
    },
    assignmentData: {
      deep: true,
      handler: function (newVal) {
        this.assignmentForm = { ...newVal };
      }
    }
  },
  methods: {
    onDialogClose() {
      this.$emit('dialog-closed');
    },
    submitForm() {
      this.assignmentData.id ? this.$emit('update-assignment', this.assignmentForm) : this.$emit('create-assignment', this.assignmentForm)
      this.onDialogClose();
    }
  }
};
</script>

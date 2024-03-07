<template>
    <el-dialog
      title="Modify Course"
      v-model="showModifyCourseDialog"
      width="50%"
      @close="onDialogClose">
      <el-form :model="localCourseForm" ref="courseForm" label-width="120px">
        <el-form-item label="Name">
          <el-input v-model="localCourseForm.name"></el-input>
        </el-form-item>
        <el-form-item label="Semester">
          <el-input v-model="localCourseForm.semester"></el-input>
        </el-form-item>
        <el-form-item label="Start Time">
          <el-date-picker
            v-model="localCourseForm.start_time"
            type="datetime"
            placeholder="Select start time">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="Duration (hours)">
          <el-input-number v-model="localCourseForm.duration" :min="1"></el-input-number>
        </el-form-item>
        <el-form-item label="Repeat">
          <el-select v-model="localCourseForm.repeat" placeholder="Select">
            <el-option label="Do not repeat" value="no-repeat"></el-option>
            <el-option label="Weekly" value="weekly"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item v-if="localCourseForm.repeat !== 'no-repeat'" label="Occurrences">
          <el-input-number v-model="localCourseForm.occurrence" :min="1" :step="1"></el-input-number>
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
    name: 'ModifyCourseDialog',
    emits: ['dialog-closed', 'update-course'],
    props: {
      courseForm: {
        type: Object,
        default: () => ({})
      },
      visible: Boolean
    },
    data() {
      return {
        localCourseForm: this.courseForm,
        showModifyCourseDialog: false
      };
    },
    watch: {
      courseForm: {
        deep: true,
        handler(newVal) {
          this.localCourseForm = { ...newVal };
        }
      },
      visible: {
        handler(newVal) {
            this.showModifyCourseDialog = newVal
        }
      }
    },
    methods: {
      submitForm() {
        this.$refs.courseForm.validate((valid) => {
          if (valid) {
            this.$emit('update-course', this.localCourseForm);
            this.showModifyCourseDialog = false;
          } else {
            console.log('error submit!!');
            return false;
          }
        });
      },
      onDialogClose() {
        this.showModifyCourseDialog = false;
        this.$emit('dialog-closed');
      }
    }
  }
  </script>
  
  <style scoped>
  .dialog-footer {
    text-align: right;
  }
  </style>
  
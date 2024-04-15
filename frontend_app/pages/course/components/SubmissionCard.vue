<template>
  <el-card class="submission" shadow="never">
    <template #header>
      <h3 @click="expandSubmission = !expandSubmission" class="submission-header">
        <div class="icon-container" :class="{ 'rotate-icon': expandSubmission }"></div>
        <span>{{ assignment.name }}</span>
        <p class="due-text">Due at: {{ getLocalDateString(assignment.due_at) }}</p>
      </h3>
    </template>
    <p>{{ assignment.description }}</p>
    <p v-for="submission in submissions" :key="submission.id">{{ submission.name }}</p>
    <div v-if="expandSubmission" class="submission-content">
      <el-button v-show="!showUploadSection" @click="showUploadSection=true" type="primary" style="margin: 10px 0;">Start Assignment</el-button>
      <el-collapse-transition>
        <div v-show="showUploadSection" class="submission-upload">
          <h3>File Upload</h3>
            <el-upload
              class="upload-demo"
              drag
              :on-remove="handleRemove"
              :on-change="beforeUpload"
              :auto-upload="false"
              :limit="1"
              :on-exceed="handleExceed"
              :file-list="fileList"
            >
              <el-icon class="el-icon--upload"><upload-filled /></el-icon>
              <div class="el-upload__text">Add File</div>
              <div class="el-upload__tip" slot="tip">Only .rmd and .md files are allowed</div>
            </el-upload>
          <el-input
            type="textarea"
            placeholder="Comments..."
            v-model="comments"
            class="submission-comments"
          ></el-input>
          <div class="dialog-footer">
            <el-button @click="cancelUpload">Cancel</el-button>
            <el-button type="primary" @click="submitAssignment">Submit Assignment</el-button>
          </div>
        </div>
      </el-collapse-transition>
    </div>
    
    <div class="btn-container">
      <el-button @click="$emit('edit-assignment', assignment)" type="primary">Edit</el-button>
      <el-button @click="$emit('delete-assignment', assignment)" type="danger">Delete</el-button>
    </div>
  </el-card>

</template>

<script>
import apiClient from '../../../lib/apiClient'
import { ElMessage } from 'element-plus'

export default {
  emits: ['edit-assignment', 'delete-assignment'],
  props: {
    assignment: {
      type: Object,
      required: true
    },
  },
  data() {
    return {
      expandSubmission: false,
      showUploadSection: false,
      file_name: '',
      comments: '',
      fileList: [],
      submissions: []
    }
  },
  watch: {
    expandSubmission: function (newVal) {
      if (newVal) {
        this.fetchSubmissions()
      }
    }
  },
  methods: {
    startAssignment() {
      this.showUploadSection = true;
    },
    cancelUpload() {
      this.showUploadSection = false;
    },
    submitAssignment() {
      if (!this.fileList.length) {
        ElMessage.error('Please add a file.')
        return;
      }

      let file_name = this.fileList[0].name;
      const reader = new FileReader();
      reader.onload = e => {
        const content = e.target.result;
        const formData = {};
        formData['name'] = file_name;
        formData['content'] = content;
        formData['comment'] = this.comments;
        this.postSubmission(formData)
      };
      reader.onerror = () => {
        ElMessage.error('Error reading file.')
      };
      reader.readAsText(this.fileList[0].raw);
    },
    beforeUpload(file) {
      const allowedTypes = ['Rmd', 'md'];
      const isRmdOrMd = allowedTypes.some(type => file.name.includes(`.${type}`));
      const isExceedingLimit = this.fileList.length >= 1;
      
      if (!isRmdOrMd) {
        ElMessage.error('Only .rmd and .md files are allowed!')
        this.fileList = []
        return false;
      }
      
      if (isExceedingLimit) {
        ElMessage.error('You can only upload one file!')
        return false;
      }
      
      this.fileList = [file];
      return true;
    },
    handleExceed(files, fileList) {
      ElMessage.error('You can only upload one file!')
    },
    handleRemove(file, fileList) {
      this.fileList = this.fileList.filter(item => item.uid !== file.uid);
    },
    fetchSubmissions() {
      apiClient.getSubmissions(this.assignment.courseId, this.assignment.id)
        .then(response => {
          this.submissions = response.data.submission;
        })
        .catch(error => {
          console.error("Error fetching submissions:", error);
        });
    },
    postSubmission(submission) {
      apiClient.postSubmission(this.assignment.course_id, this.assignment.id,  submission)
        .then(response => {
          this.showUploadSection = false;
          this.fetchSubmissions();
        })
        .catch(error => {
          console.error("Error updating submission:", error);
        });
    },
    editSubmission(submission) {
      apiClient.updateSubmission(this.assignment.courseId, this.assignment.id, submission.id, submission)
        .then(response => {
          this.fetchSubmissions();
        })
        .catch(error => {
          console.error("Error updating submission:", error);
        });
    },
    deleteSubmission(submissionId) {
      apiClient.deleteSubmission(this.assignment.courseId, this.assignment.id, submissionId)
        .then(response => {
          this.fetchSubmissions();
        })
        .catch(error => {
          console.error("Error deleting submission:", error);
        });
    },
    getLocalDateString(utcStr=null) {
      if (typeof utcStr !== 'string') {
        return false;
      }
      const parts = utcStr.match(/(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2}) \+0000/);
      if (!parts) {
        console.error('Invalid date format:', utcStr);
        return false;
      }

      const date = new Date(Date.UTC(parts[1], parts[2] - 1, parts[3], parts[4], parts[5], parts[6]));

      return date.getFullYear()
        + '-' + String(date.getMonth() + 1).padStart(2, '0')
        + '-' + String(date.getDate()).padStart(2, '0')
        + ' ' + String(date.getHours()).padStart(2, '0')
        + ':' + String(date.getMinutes()).padStart(2, '0');
    }
  },
  created() {
    // this.fetchSubmissions();
  }
};
</script>

<style scoped>
.submission {
  text-align: left;
  width: 100%;
  margin: 10px 0;
}
.submission-header {
  cursor: pointer;
}
.btn-container {
  z-index: 999;
  display: flex;
  justify-content: flex-end;
  padding: 10px 0 0 0;
}
.dialog-footer {
  padding: 10px 0 0 0;
}
.due-text {
  color: #9e9e9e;
  font-weight: 500;
  float: right;
  font-size: 1rem;
}
.icon-container {
  display: inline-block;
  margin-right: 5px;
  width: 0; 
  height: 0; 
  border-left: 8px solid transparent;
  border-right: 8px solid transparent;
  border-top: 12px solid black;
  transition: transform 0.3s ease;
  border-radius: 0;
  transform: rotate(-90deg);
}

.rotate-icon {
  transform: rotate(0deg);
}

.btn-container {
  clear: both;
  padding-top: 10px;
}
.submission-content {
  margin: 10px 0;
}
</style>

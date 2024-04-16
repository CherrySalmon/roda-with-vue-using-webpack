<template>
  <el-card class="submission" shadow="never">
    <template #header>
      <h3 class="submission-header">
        <span>{{ assignment.name }}</span>
        <p class="due-text">Due at: {{ getLocalDateString(assignment.due_at) }}</p>
      </h3>
    </template>
    <p>{{ assignment.description }}</p>
    <template v-if="currentRole=='student'">
      <h3 class="submission-subtitle">Submitted</h3>
      <el-empty v-if="submissions.length < 1"  description="No Data" />
      <div v-for="(submission, i) in submissions" :key="submission.id" class="submitted-container">
        <div class="submission-preview-btn submit-text" @click="submission.dialogVisible = true">{{ submission.name }}</div>
        <div class="submit-text submit-date-text">{{  getLocalDateString(submission.updated_at) }}</div>
        <el-dialog v-model="submission.dialogVisible" :title="submission.name" :width="dialogWidth">
          <div class="submission-preview-btn" style="margin: 10px 0;" @click="downloadFile(submission.name, submission.content)">Download</div>
          <h3>Comment</h3>
          <div class="submission-comment-text">{{ submission.comment }}</div>
          <h3>Content</h3>
          <div class="submission-content-text">{{ submission.content }}</div>
        </el-dialog>
      </div>
      <div class="submission-content">
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
    </template>
    
    <template v-if="currentRole!='student'">
      <div class="btn-container">
        <el-button @click="downloadZip()" type="success">Download All</el-button>
        <el-button @click="$emit('edit-assignment', assignment)" type="primary">Edit</el-button>
        <el-button @click="$emit('delete-assignment', assignment)" type="danger">Delete</el-button>
      </div>

      <h3>Students' Submissions</h3>
      <el-empty v-if="allSubmissions.length < 1"  description="No Data" />
      <div v-for="(submission, i) in allSubmissions" :key="submission.id" class="submitted-container">
        <div class="submission-preview-btn submit-text" @click="submission.dialogVisible = true">{{ submission.name }}</div>
        <div class="submit-text">{{ submission.account_name }}</div>
        <div class="submit-text">{{ submission.account_email }}</div>
        <div class="submit-text submit-date-text">{{  getLocalDateString(submission.updated_at) }}</div>
        <el-dialog v-model="submission.dialogVisible" :title="submission.name" :width="dialogWidth">
          <div class="submission-preview-btn" @click="downloadFile(submission.name, submission.content)">Download</div>
          <h3>Comment</h3>
          <div class="submission-comment-text">{{ submission.comment }}</div>
          <h3>Content</h3>
          <div class="submission-content-text">{{ submission.content }}</div>
        </el-dialog>
      </div>
    </template>
  </el-card>

</template>

<script>
import apiClient from '../../../lib/apiClient'
import { ElMessage } from 'element-plus'
import JSZip from 'jszip';
import { saveAs } from 'file-saver';

export default {
  emits: ['edit-assignment', 'delete-assignment'],
  props: {
    assignment: {
      type: Object,
      required: true
    },
    currentRole: String
  },
  data() {
    return {
      showUploadSection: false,
      file_name: '',
      comments: '',
      fileList: [],
      submissions: [],
      allSubmissions: [],
      dialogWidth: "800px",
    }
  },
  watch: {
    currentRole: function(newVal, oldVal) {
      if (newVal != 'student' && oldVal == 'student') {
        this.fetchAllSubmissions()
      }
    }
  },
  created() {
    this.fetchSubmissions();
    if (this.currentRole != 'student') {
      this.fetchAllSubmissions()
    }
  },
  mounted() {
    window.onresize = () => {
      return (() => {
        this.setDialogWidth();
      })();
    };
  },
  methods: {
    downloadFile(fileName, content) {
      const blob = new Blob([content], { type: 'text/markdown;charset=utf-8;' });
      const link = document.createElement('a');
      link.href = URL.createObjectURL(blob);
      link.download = fileName;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    },
    downloadZip() {
      const zip = new JSZip();
      this.allSubmissions.forEach(file => {
        zip.file(file.id+'_'+file.account_name+'_'+file.name, file.content);
      });
      zip.generateAsync({type:"blob"})
        .then((content) => {
          saveAs(content, this.assignment.name+".zip");
        });
    },
    setDialogWidth() {
      let windowSize = document.body.clientWidth;
      const defaultWidth = 800;
      if (windowSize < defaultWidth) {
        this.dialogWidth = "100%";
      } else {
        this.dialogWidth = defaultWidth + "px";
      }
    },
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
      apiClient.getSubmissions(this.assignment.course_id, this.assignment.id)
        .then(response => {
          this.submissions = response.data.submission;
        })
        .catch(error => {
          console.error("Error fetching submissions:", error);
        });
    },
    fetchAllSubmissions() {
      apiClient.getAllSubmissions(this.assignment.course_id, this.assignment.id)
        .then(response => {
          this.allSubmissions = response.data.submission;
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
      apiClient.updateSubmission(this.assignment.course_id, this.assignment.id, submission.id, submission)
        .then(response => {
          this.fetchSubmissions();
        })
        .catch(error => {
          console.error("Error updating submission:", error);
        });
    },
    deleteSubmission(submissionId) {
      apiClient.deleteSubmission(this.assignment.course_id, this.assignment.id, submissionId)
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
.submission-subtitle {
  margin: 20px 0 0 0;
}
.submission-preview-btn {
  color: rgb(18, 118, 206);
  text-decoration: underline;
  cursor: pointer;
}
.submit-text {
  width: 20%;
  min-width: fit-content;
}
.submit-date-text {
  text-align: right;
}
@media (max-width: 1248px) {
  .submit-text {
    width: 50%;
  }
  .submit-date-text {
    text-align: left;
    
  }
}
.submission-comment-text {
  padding: 10px 15px;
  margin: 5px 0;
  background-color: #e9e9e9;
  border-radius: 3px;
}
.submission-content-text {
  padding: 10px 15px;
  margin: 5px 0;
  border: 1px solid #e9e9e9;
  border-radius: 3px;
  white-space: pre-wrap;
}
.submitted-container {
  display: flex;
  flex-wrap: wrap;
  margin: 20px 0;
  justify-content: space-between;
}
.btn-container {
  z-index: 999;
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-end;
  padding: 10px 0 0 0;
}
.btn-container >>> button {
  margin: 10px 5px;
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

.submission-content {
  margin: 10px 0;
}
</style>

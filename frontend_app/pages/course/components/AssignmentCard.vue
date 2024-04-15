<template>
  <div class="event-card-container course-card-container">
    <div class="course-content-title">Attendance Events</div>
    <el-button @click="showAssignmentDialog = true">+ Create assignment</el-button>
    <submission
      v-for="assignment in assignments"
      :key="assignment.id"
      :assignment="assignment"
      @edit-assignment="editAssignment"
      @delete-assignment="deleteAssignemnt"
    />
    <AssignmentDialog 
      :assignmentData="newAssignment"
      :visible="showAssignmentDialog"
      @dialog-closed="dialogClosed"
      @create-assignment="createAssignment"
      @update-assignment="updateAssignment"
    />
  </div>
</template>

<script>
import apiClient from '../../../lib/apiClient';
import Submission from './SubmissionCard.vue';
import AssignmentDialog from './AssignmentDialog.vue'

export default {
  emits: ['create-event', 'edit-event', 'delete-event', 'create-location', 'update-location', 'delete-location', 'new-enrolls', 'update-enrollment', 'delete-enrollment'],
  props: {
    course: Object,
    attendanceEvents: Object,
    locations: Array,
    enrollments: Object, 
    currentRole: String
  },
  components: {
    Submission, AssignmentDialog
  },
  data() {
    return {
      assignments: [],
      newAssignment: {},
      showAssignmentDialog: false,
    };
  },
  created() {
    this.fetchAssignments()
  },
  methods: {
    editAssignment(assignmentData) {
      console.log(assignmentData)
      this.newAssignment = assignmentData
      this.showAssignmentDialog =  true
    },
    dialogClosed() {
      this.showAssignmentDialog = false;
      this.newAssignment = {}
    },
    fetchAssignments() {
      apiClient.getAssignments(this.course.id)
        .then(response => {
          this.assignments = response.data.assignments;
        })
        .catch(error => {
          console.error("Error fetching assignments:", error);
        });
    },
    createAssignment(assignmentData) {
      apiClient.postAssignment(this.course.id, assignmentData)
        .then(response => {
          this.fetchAssignments();
        })
        .catch(error => {
          console.error("Error creating assignment:", error);
        });
    },
    updateAssignment(assignmentData) {
      let newAssignment = { ...assignmentData}
      delete newAssignment.id
      apiClient.updateAssignment(this.course.id, assignmentData.id, newAssignment)
        .then(response => {
          this.fetchAssignments()
        })
        .catch(error => {
          console.error("Error creating assignment:", error);
        });
    },
    deleteAssignemnt(assignmentData) {
      apiClient.deleteAssignment(assignmentData.courseId, assignmentData.id)
        .then(response => {
          this.fetchAssignments()
        })
        .catch(error => {
          console.error("Error deleting submission:", error);
      });
    },
  }
};
</script>

<style scoped>
.event-card-container {
  display: flex;
  justify-content: flex-start;
  flex-wrap: wrap;
}
@media (max-width: 768px) {
  .event-card-container {
    justify-content: center;
  }
}
</style>

<template>
    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span>Course Information</span>
          <template v-if="course.enroll_identity">
            <template v-if="course.enroll_identity != 'student'">
                <el-button type="warning" @click="$emit('show-modify-dialog')" text style="font-weight: 700;">Modify Course</el-button>
            </template>
          </template>
        </div>
      </template>
      <div>
        <p>Semester: {{ course.semester }}</p>
        <p>Start Time: {{ formatDateTime(course.start_time) || 'N/A' }}</p>
        <p>Duration: {{ course.duration ? course.duration + ' hours' : 'N/A' }}</p>
        <p>Repeat: {{ course.repeat || 'N/A' }}</p>
        <p>Occurrence: {{ course.occurrence || 'N/A' }}</p>
      </div>
    </el-card>
  </template>
  
  <script>
  export default {
    props: ['course'],
    emits: ['show-modify-dialog'],
    data() {
        return {}
    },
    methods: {
        formatDateTime(datestring) {
            let date = new Date(datestring)
            const year = date.getFullYear();

            // getMonth() returns month from 0-11; add 1 to make it 1-12
            const month = ('0' + (date.getMonth() + 1)).slice(-2);
            
            const day = ('0' + date.getDate()).slice(-2);
            
            const hours = ('0' + date.getHours()).slice(-2);
            
            const minutes = ('0' + date.getMinutes()).slice(-2);
            
            // Combine the parts
            return `${year}/${month}/${day} ${hours}:${minutes}`;
        }
    }
}
</script>
  
<template>
  <el-card class="box-card">
    <template #header>
      <div class="card-header">
        <span>Course Information</span>
        <template v-if="currentRole">
          <template v-if="currentRole != 'student'">
            <el-button type="warning" @click="$emit('show-modify-dialog')" text style="font-weight: 700;">Modify
              Course</el-button>
          </template>
        </template>
      </div>
    </template>
    <div>
      <p>Start Time: {{ getLocalDateString(course.start_time) || 'N/A' }}</p>
      <p>Duration: {{ course.duration ? course.duration + ' hours' : 'N/A' }}</p>
      <p>Repeat: {{ course.repeat || 'N/A' }}</p>
      <p>Occurrence: {{ course.occurrence || 'N/A' }}</p>
    </div>
  </el-card>
</template>
  
<script>
export default {
  props: ['course', 'currentRole'],
  emits: ['show-modify-dialog'],
  data() {
    return {}
  },
  methods: {
    getLocalDateString(utcStr) {
      if (typeof utcStr !== 'string') {
        console.error('getLocalDateString called with non-string input:', utcStr);
        return 'Invalid Date'; // Or any other default/fallback value you see fit
      }
      // Manually parsing the date string to components
      const parts = utcStr.match(/(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2}) \+0000/);
      if (!parts) {
        console.error('Invalid date format:', utcStr);
        return 'Invalid Date';
      }

      // Creating a Date object using the parsed components
      // Note: Months are 0-indexed in JavaScript Date, hence the -1 on month part
      const date = new Date(Date.UTC(parts[1], parts[2] - 1, parts[3], parts[4], parts[5], parts[6]));

      // Formatting the Date object to a local date string
      return date.getFullYear()
        + '-' + String(date.getMonth() + 1).padStart(2, '0')
        + '-' + String(date.getDate()).padStart(2, '0')
        + ' ' + String(date.getHours()).padStart(2, '0')
        + ':' + String(date.getMinutes()).padStart(2, '0');
    }
  }
}
</script>
  
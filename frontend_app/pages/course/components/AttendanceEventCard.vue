<template>
    <el-card v-for="event in attendanceEvents" :key="event.id" class="event-item" shadow="hover">
      <div style="padding: 14px">
        <h3>{{ event.name }}</h3>
        <!-- <p>Start Time: {{ event.start_time }}</p>
        <p>End Time: {{ event.end_time }}</p> -->
      </div>
      <el-icon :size="18" @click="$emit('edit-event', event.id)">
        <Edit />
      </el-icon>
      <span style="margin-left: 10px;"></span> <!-- Add space between icons -->
      <el-icon :size="18" @click.stop="$emit('delete-event', event.id)">
        <Delete />
      </el-icon>
    </el-card>
</template>
  
<script>
  export default {
    emits: ['edit-event', 'delete-event'],
    props: {
        attendanceEvents: {
        type: Object,
        default: () => ({})
      }
    },
    data() {
        return {
        }
    },
    watch: {
    },
    methods: {
    }
}
</script>
  
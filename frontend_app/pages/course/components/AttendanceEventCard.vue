<template>
    <el-card v-for="event in attendanceEvents" :key="event.id" class="event-item" shadow="hover">
      <div style="">
        <h3>{{ event.name }}</h3>
        <p>Location: {{ getEventLocationName(event.location_id) }}</p>
        <!-- <p>Start Time: {{ event.start_time }}</p>
        <p>End Time: {{ event.end_time }}</p> -->
        <el-icon :size="18" @click="$emit('edit-event', event.id)">
          <Edit />
        </el-icon>
        <span style="margin-left: 10px;"></span> <!-- Add space between icons -->
        <el-icon :size="18" @click.stop="$emit('delete-event', event.id)">
          <Delete />
        </el-icon>
      </div>
      
    </el-card>
</template>
  
<script>
  export default {
    emits: ['edit-event', 'delete-event'],
    props: {
        attendanceEvents: {
        type: Object,
        default: () => ({})
      },
      locations: Array
    },
    data() {
        return {
        }
    },
    watch: {
    },
    methods: {
      getEventLocationName(locationId) {
          const location = this.locations.find(loc => loc.value === locationId);
          return location ? location.label : 'Unknown Location'; // Provide a fallback name
      }
    }
}
</script>
  
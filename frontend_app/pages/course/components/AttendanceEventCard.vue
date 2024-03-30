<template>
  <div class="event-card-container course-card-container">
    <div class="course-content-title">Attendance Events</div>
    <el-card class="event-item" shadow="hover" @click.stop="$emit('create-event')">
      <h3>Create Event</h3>
      <el-icon :size="24" style="margin-top: 10px;"><DocumentAdd /></el-icon>
    </el-card>
    <el-card v-for="event in attendanceEvents" :key="event.id" class="event-item" shadow="always" style="background-color: #f2f2f2">
      <div style="">
        <h3>{{ event.name }}</h3>
        <p>Location: {{ getEventLocationName(event.location_id) }}</p>
        <!-- <p>Start Time: {{ event.start_at }}</p>
        <p>End Time: {{ event.end_at }}</p> -->
        <el-icon :size="18" @click="$emit('edit-event', event.id)">
          <Edit />
        </el-icon>
        <span style="margin-left: 10px;"></span>
        <el-icon :size="18" @click.stop="$emit('delete-event', event.id)">
          <Delete />
        </el-icon>
      </div>   
    </el-card>
  </div>
    
</template>
  
<script>
  export default {
    emits: ['create-event', 'edit-event', 'delete-event', 'create-location', 'update-location', 'delete-location', 'new-enrolls', 'update-enrollment', 'delete-enrollment'],
    props: {
      attendanceEvents: Object,
      locations: Array,
      enrollments: Object, 
      currentRole: String
    },
    data() {
        return {
        }
    },
    watch: {
    },
    methods: {
      getEventLocationName(locationId) {
          const location = this.locations.find(loc => loc.id === locationId);
          return location ? location.name : 'Unknown Location'; // Provide a fallback name
      }
    }
}
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

.event-item {
  width: 20%;
  min-width: 200px;
  margin: 10px;
  padding: 0px;
}

</style>
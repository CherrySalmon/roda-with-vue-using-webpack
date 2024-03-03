<template>
  <div class="single-course-container">
    <div class="page-title">{{ course.name }}</div>
    <el-row>
      <el-col :xs="24" :sm="18">
        <el-tabs tab-position="left" style="height: 100%; text-align: left;" @tab-change="changeTab" v-model="activeTab">
          <div v-if="course.enroll_identity">
            <div
              v-if="course.enroll_identity.includes('owner') || course.enroll_identity.includes('instructor') || course.enroll_identity.includes('staff')">

              <el-tab-pane label="Attendance Events" name="events">
                <h3 style="margin: 30px 20px 10px 20px;">Attendance Events</h3>
                <AttendanceEventCard :attendance-events="attendanceEvents" @edit-event="editAttendanceEvent"
                  @delete-event="deleteAttendanceEvent">
                </AttendanceEventCard>
              </el-tab-pane>
              <el-tab-pane label="Locations" name="locations">
                <h3 style="margin: 30px 20px 10px 20px;">Locations</h3>
                <LocationCard :locations="locations" @create-location="createNewLocation"
                  @delete-location="deleteLocation"></LocationCard>
              </el-tab-pane>
              <el-tab-pane label="People" name="people">
                <h3 style="margin: 30px 20px 10px 20px;">People</h3>
                <ManagePeopleCard :enrollments="enrollments" @new-enrolls="addEnrollments"
                  @update-enrollment="updateEnrollment" @delete-enrollment="deleteEnrollments">
                </ManagePeopleCard>
              </el-tab-pane>
            </div>
          </div>
        </el-tabs>
      </el-col>

      <el-col :xs="24" :sm="6">
        <div v-if="course.enroll_identity">
          <div v-if="course.enroll_identity.includes('student') && course.enroll_identity.split(',').length > 1">
            <el-button style="margin: 20px 0;" type="primary" @click="changeRoute($route.params.id + '/attendance')">Mark
              Attendance</el-button>
          </div>
          <div v-if="course.enroll_identity != 'student'">
            <el-button type="primary" @click="showCreateAttendanceEventDialog = true">Create Event</el-button>
            <CourseInfoCard :course="course" @show-modify-dialog="showModifyCourseDialog = true" style="margin: 20px 0;">
            </CourseInfoCard>
          </div>
        </div>
      </el-col>
    </el-row>
    <div v-if="course.enroll_identity">
      <div class="center-content"
        v-if="course.enroll_identity.includes('student') && course.enroll_identity.split(',').length == 1">
        <el-button type="primary" @click="changeRoute($route.params.id + '/attendance')">Mark Attendance</el-button>
        <CourseInfoCard :course="course" @show-modify-dialog="showModifyCourseDialog = true" style="margin: 20px 0;">
        </CourseInfoCard>
      </div>
    </div>
    <!-- Modify Course Dialog -->
    <ModifyCourseDialog :courseForm="courseForm" :visible="showModifyCourseDialog"
      @dialog-closed="showModifyCourseDialog = false" @update-course="updateCourse"></ModifyCourseDialog>

    <CreateAttendanceEventDialog :visible="showCreateAttendanceEventDialog" :locations="locations"
      @dialog-closed="showCreateAttendanceEventDialog = false" @create-event="createAttendanceEvent">
    </CreateAttendanceEventDialog>

    <ModifyAttendanceEventDialog :eventForm="createAttendanceEventForm" :visible="showModifyAttendanceEventDialog"
      :locations="locations" @dialog-closed="showModifyAttendanceEventDialog = false"
      @update-event="updateAttendanceEvent">
    </ModifyAttendanceEventDialog>
  </div>
</template>

<script>
import axios from 'axios';
import cookieManager from '../../lib/cookieManager';
import CourseInfoCard from './components/CourseInfoCard.vue';
import ModifyCourseDialog from './components/ModifyCourseDialog.vue';
import ManagePeopleCard from './components/ManagePeopleCard.vue';
import CreateAttendanceEventDialog from './components/CreateAttendanceEventDialog.vue';
import ModifyAttendanceEventDialog from './components/ModifyAttendanceEventDialog.vue'
import AttendanceEventCard from './components/AttendanceEventCard.vue';
import LocationCard from './components/LocationCard.vue'

export default {
  name: 'SingleCourse',
  components: { CourseInfoCard, ModifyCourseDialog, ManagePeopleCard, CreateAttendanceEventDialog, AttendanceEventCard, ModifyAttendanceEventDialog, LocationCard },
  data() {
    return {
      course: {
      },
      courseForm: {
      },
      attendanceEventForm: {},
      createAttendanceEventForm: {
        name: '',
        location_id: '',
        start_time: '',
        end_time: '',
      },
      attendanceEvents: [],
      locations: [],
      optionLocation: '',
      account: {
        roles: [],
        credential: ''
      },
      showModifyCourseDialog: false,
      showCreateAttendanceEventDialog: false,
      showModifyAttendanceEventDialog: false,
      isAddedValue: false,
      enrollments: [],
      currentEventID: '',
      activeTab: 'people'
    };
  },

  created() {
    this.course.id = this.$route.params.id;
    this.account = cookieManager.getAccount()
    if (this.account) {
      this.fetchCourse(this.course.id);
      this.fetchAttendanceEvents(this.course.id);
      this.fetchLocations();
    }
    else {
      console.log(this.$route)
      this.$router.push({ path: '/login', query: { redirect: this.$route.href } })
    }
    this.fetchEnrollments()
  },

  methods: {
    changeTab(tab_name) {
      console.log(tab_name)
      if (tab_name == 'people') {
        this.fetchEnrollments()
      }
    },
    changeRoute(route) {
      this.$router.push({ path: route })
    },
    fetchCourse(id) {
      axios.get(`/api/course/${id}`, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        },
      }).then(response => {
        this.course = response.data.data;
        // Copying the course object to courseForm
        this.courseForm = { ...this.course };

        // Deleting the id and enroll_identity keys from courseForm
        delete this.courseForm.id;
        delete this.courseForm.enroll_identity;
      }).catch(error => {
        console.error('Error fetching course:', error);
      });
    },
    updateCourse(form) {
      this.courseForm = form
      if (this.courseForm.repeat == 'no-repeat') {
        this.courseForm.occurrence = 1
      }
      axios.put('api/course/' + this.course.id, this.courseForm, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        },
      }).then(() => {
        this.showModifyCourseDialog = false;
        this.fetchCourse(this.course.id);
      }).catch(error => {
        console.error('Error creating course:', error);
      });
    },
    fetchEnrollments() {
      axios.get(`/api/course/${this.course.id}/enroll`, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        }
      }).then(response => {
        this.enrollments = response.data.data;
        this.enrollments.forEach((enrollment) => {
          enrollment.enrolls = enrollment.enroll_identity.split(',')
        });

      }).catch(error => {
        console.error('Error fetching enrollments:', error);
      });
    },

    addEnrollments(newEnrolls) {
      axios.post(`/api/course/${this.course.id}/enroll`, { enroll: newEnrolls }, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        }
      }).then(response => {
        console.log(response)
        this.fetchEnrollments()
      }).catch(error => {
        console.error('Error fetching enrollments:', error);
      });
    },

    updateEnrollment(enrollment) {
      let entollList = {
        enroll: [{
          email: enrollment.email,
          roles: enrollment.enrolls.join(',')
        }]
      }
      axios.post(`/api/course/${this.course.id}/enroll`, entollList, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        }
      }).then(response => {
        console.log(response)
      }).catch(error => {
        console.error('Error fetching enrollments:', error);
      });
    },

    deleteEnrollments(enrollment) {
      axios.delete(`/api/course/${this.course.id}/enroll/${enrollment}`, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        }
      }).then(response => {
        console.log(response)
        this.fetchEnrollments()
      }).catch(error => {
        console.error('Error fetching enrollments:', error);
      });
    },
    createAttendanceEvent(eventForm) {
      axios.post(`api/course/${this.course.id}/event`, eventForm, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        },
      }).then(() => {
        this.showCreateAttendanceEventDialog = false
        this.createAttendanceEventForm = {}
        this.fetchAttendanceEvents(); // Refresh the list after adding
      }).catch(error => {
        console.error('Error creating attendance event:', error);
      });
    },
    fetchAttendanceEvents() {
      axios.get(`api/course/${this.course.id}/event`, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        },
      }).then(response => {
        this.attendanceEvents = response.data.data;
      }).catch(error => {
        console.error('Error fetching attendance events:', error);
      });
    },
    fetchLocations() {
      axios.get(`api/course/${this.course.id}/location`, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        },
      }).then(response => {
        this.locations = response.data.data.map(location => {
          return {
            value: location.id,
            label: location.name
          }
        });

      }).catch(error => {
        console.error('Error fetching locations:', error);
      });
    },
    createNewLocation(locationData) {
      let courseId = this.$route.params.id;
      axios.post(`api/course/${courseId}/location`, locationData, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        }
      })
        .then(response => {
          console.log('Location created successfully', response);
          this.fetchLocations();
        })
        .catch(error => {
          console.error('Error creating location', error);
        });
    },
    deleteLocation(locationId) {
      axios.delete(`/api/course/${this.course.id}/location/${locationId}`, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        }
      }).then(() => {
        console.log(`Location ${locationId} deleted successfully.`);
        // Refresh the locations list
        this.fetchLocations();
      }).catch(error => {
        console.error('Error deleting location:', error);
      });
    },
    deleteAttendanceEvent(eventId) {
      axios.delete(`/api/course/${this.course.id}/event/${eventId}`, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        }
      }).then(() => {
        console.log(`Event ${eventId} deleted successfully.`);
        // Refresh the attendance events list
        this.fetchAttendanceEvents(this.course.id);
      }).catch(error => {
        console.error('Error deleting attendance event:', error);
      });
    },
    editAttendanceEvent(eventId) {
      const event = this.attendanceEvents.find(e => e.id === eventId);
      if (event) {
        // Assuming `event` is already a reactive object, you might directly assign it
        // Or use a spread operator for a shallow copy if modifications should not reflect back immediately
        this.attendanceEventForm = { ...event };
        delete this.attendanceEventForm.id;
        this.showModifyAttendanceEventDialog = true;
        this.createAttendanceEventForm = this.attendanceEventForm;
        this.currentEventID = eventId;
      } else {
        console.error('Event not found!');
      }
    },

    updateAttendanceEvent() {
      axios.put(`api/course/${this.course.id}/event/${this.currentEventID}`, this.attendanceEventForm, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        },
      }).then(() => {
        this.showModifyAttendanceEventDialog = false;
        this.fetchAttendanceEvents(); // Refresh the list after adding
      }).catch(error => {
        console.error('Error modifying attendance event:', error);
      });
    },
    onConfirm() {
      if (this.optionLocation) {
        this.locations.push({
          label: this.optionLocation,
          value: this.optionLocation,
        })
        this.clear()
      }
    },
    clear() {
      this.optionLocation = ''
      this.isAddedValue = false
    }
  },
};
</script>

<style>
.single-course-container {
  width: 100%;
  padding: 15px 40px 85px;
}

.event-item {
  border-bottom: 1px solid #eee;
  padding: 20px 5px;
  width: 200px;
  margin: 20px;
  cursor: pointer;
  display: inline-block;
  font-size: 12px;
}

.option-input {
  width: 90%;
  margin-bottom: 8px;
  margin-left: 5%;
}

.box-card {
  text-align: left;
  line-height: 2rem;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.center-content {
  margin: auto;
  width: 50%;
  /* Adjust as needed */
  /* Space between the button and the CourseInfoCard */
}
</style>
``

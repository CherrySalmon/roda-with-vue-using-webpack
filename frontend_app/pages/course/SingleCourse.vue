<template>
  <div class="single-course-container">
    <div class="page-title">{{ course.name }}</div>
    <el-row>
      <el-col :xs="24" :md="18">
        <el-tabs :tab-position="tabStyle" style="height: 100%; text-align: left;" @tab-change="changeTab" v-model="activeTab">
          <div v-if="currentRole">
            <div
              v-if="currentRole =='owner' || currentRole =='instructor' || currentRole =='staff'">
              <el-tab-pane label="Attendance Events" name="events">
                <h3 style="margin: 30px 20px 10px 20px;">Attendance Events</h3>
                <AttendanceEventCard :attendance-events="attendanceEvents" :locations="locations" @edit-event="editAttendanceEvent"
                  @delete-event="deleteAttendanceEvent">
                </AttendanceEventCard>
              </el-tab-pane>
              <el-tab-pane label="Locations" name="locations">
                <h3 style="margin: 30px 20px 10px 20px;">Locations</h3>
                <div v-if="isGetCurrentLocation">
                  <LocationCard :locations="locations" :currentLocationData="currentLocationData" @create-location="createNewLocation"
                    @delete-location="deleteLocation"></LocationCard>
                </div>
              </el-tab-pane>
              <el-tab-pane label="People" name="people">
                <h3 style="margin: 30px 20px 10px 20px;">People</h3>
                <ManagePeopleCard :enrollments="enrollments" @new-enrolls="addEnrollments"
                  @update-enrollment="updateEnrollment" @delete-enrollment="deleteEnrollments"
                  :currentRole="currentRole">
                </ManagePeopleCard>
              </el-tab-pane>
            </div>
          </div>
        </el-tabs>
      </el-col>

      <el-col :xs="24" :md="6">
        <div v-if="currentRole">
          <div v-if="currentRole != 'student'">
            <el-button type="primary" @click="showCreateAttendanceEventDialog = true">Create Event</el-button>
            <CourseInfoCard :course="course" :currentRole="currentRole" @show-modify-dialog="showModifyCourseDialog = true" style="margin: 20px 0;">
            </CourseInfoCard>
            <div class="selecor-role-container">
              <span style="margin: 0 10px;">View</span>
              <el-select
                v-model="selectRole"
                placeholder="Select"
                size="large"
                style="width: 100%;"
                @change="changeRole"
              >
                <el-option
                  v-for="role in selectableRoles"
                  :key="role"
                  :label="role"
                  :value="role"
                />
              </el-select>
            </div>
          </div>
        </div>
      </el-col>
    </el-row>
    <div v-if="currentRole">
      <div class="center-content" v-if="currentRole =='student'">
        <el-button type="primary" @click="changeRoute($route.params.id + '/attendance')">Mark Attendance</el-button>
        <CourseInfoCard :course="course" :role="currentRole" @show-modify-dialog="showModifyCourseDialog = true" style="margin: 20px 0;">
        </CourseInfoCard>
        <div class="selecor-role-container">
          <span style="margin: 0 10px;">View</span>
          <el-select
            v-model="selectRole"
            placeholder="Select"
            size="large"
            style="width: 100%;"
            @change="changeRole"
          >
            <el-option
              v-for="role in selectableRoles"
              :key="role"
              :label="role"
              :value="role"
            />
          </el-select>
        </div>
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
import { ElMessage } from 'element-plus'

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
        start_at: '',
        end_at: '',
      },
      attendanceEvents: [],
      locations: [],
      currentLocationData: {},
      optionLocation: '',
      account: {
        roles: [],
        credential: ''
      },
      selectableRoles: [],
      currentRole: '',
      selectRole: '',
      showModifyCourseDialog: false,
      showCreateAttendanceEventDialog: false,
      showModifyAttendanceEventDialog: false,
      isAddedValue: false,
      isGetCurrentLocation: false,
      enrollments: [],
      currentEventID: '',
      activeTab: 'events'
    };
  },
  computed: {
    tabStyle() {
      if (window.innerWidth < 992) {
        return "top"
      }
      return "left"
    }
  },
  created() {
    this.course.id = this.$route.params.id;
    this.account = cookieManager.getAccount()
    if (this.account) {
      this.fetchCourse(this.course.id);
    }
  },
  watch: {
    currentRole(newRole) {
      if(newRole == 'owner' || newRole == 'instructor' || newRole == 'staff') {
        this.fetchAttendanceEvents(this.course.id);
        this.fetchLocations();
        this.getCurrentLocation();
        this.fetchEnrollments();
      }
    }
  },
  methods: {
    changeRole(role) {
      ElMessageBox.confirm(
        'page will change to '+role+' view. Continue?',
        'Warning',
        {
          confirmButtonText: 'OK',
          cancelButtonText: 'Cancel',
          type: 'warning',
        }
      )
        .then(() => {
          this.currentRole = role
          ElMessage({
            type: 'success',
            message: 'Change to '+role+' view',
          })
        })
        .catch(() => {
          this.selectRole = this.currentRole
          ElMessage({
            type: 'info',
            message: 'Change canceled',
          })
        })
    },
    changeTab(tab_name) {
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
        this.selectableRoles = this.course.enroll_identity
        this.selectRole = this.selectableRoles[0]
        this.currentRole = this.selectRole
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
      axios.put('/api/course/' + this.course.id, this.courseForm, {
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
          enrollment.enrolls = response.data.data.enroll_identity
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
        this.fetchEnrollments()
      }).catch(error => {
        console.error('Error fetching enrollments:', error);
        ElMessage.error(error.message)
      });
    },

    updateEnrollment(enrollment) {
      let entollList = {
        enroll: {
          email: enrollment.account.email,
          roles: enrollment.enroll_identity.join(',')
        }
      }
      axios.post(`/api/course/${this.course.id}/enroll/${enrollment.account.id}`, entollList, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        }
      }).then(response => {
        this.fetchEnrollments()
      }).catch(error => {
        console.error('Error fetching enrollments:', error);
        ElMessage.error(error.message)
      });
    },

    deleteEnrollments(enrollment) {
      axios.delete(`/api/course/${this.course.id}/enroll/${enrollment}`, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        }
      }).then(response => {
        this.fetchEnrollments()
      }).catch(error => {
        console.error('Error fetching enrollments:', error);
      });
    },
    createAttendanceEvent(eventForm) {
      console.log(eventForm)
      axios.post(`/api/course/${this.course.id}/event`, eventForm, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        },
      }).then(() => {
        this.showCreateAttendanceEventDialog = false
        this.createAttendanceEventForm = {}
        this.fetchAttendanceEvents() // Refresh the list after adding
      }).catch(error => {
        console.error('Error creating attendance event:', error);
      });
    },
    fetchAttendanceEvents() {
      axios.get(`/api/course/${this.course.id}/event`, {
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
      axios.get(`/api/course/${this.course.id}/location`, {
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
      axios.post(`/api/course/${courseId}/location`, locationData, {
        headers: {
          Authorization: `Bearer ${this.account.credential}`,
        }
      })
        .then(response => {
          alert('Location created successfully', response);
          this.fetchLocations();
        })
        .catch(error => {
          console.error('Error creating location', error);
          alert('Error creating location');
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
    getCurrentLocation() {
            // Check if Geolocation is supported
            if ("geolocation" in navigator) {
                navigator.geolocation.getCurrentPosition((position) => {
                    const { latitude, longitude } = position.coords
                    this.currentLocationData = {
                        latitude: latitude,
                        longitude: longitude
                    };
                    this.isGetCurrentLocation = true;
                }, (error) => {
                    // Handle location 
                    console.error('Error getting location', error);
                });
            } else {
                // Geolocation is not supported by this browser
                console.error('Geolocation is not supported by this browser.');
            }
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
      axios.put(`/api/course/${this.course.id}/event/${this.currentEventID}`, this.attendanceEventForm, {
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
  padding: 15px 30px;
}

.event-item {
  border-bottom: 1px solid #eee;
  text-align: center;
  padding: 10px 5px;
  width: 200px;
  margin: 20px;
  cursor: pointer;
  display: inline-block;
  font-size: 14px;
  line-height: 2.5rem;
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
  min-width: 280px;
}
.selecor-role-container {
  justify-content: space-between;
  display: flex;
  line-height: 40px;
}
</style>
``

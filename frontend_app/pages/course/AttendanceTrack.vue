<template>
    <div>
        <!-- The card element will only be shown if `isAccountDataFetched` is true -->
        <div v-if="event">
            <el-card class="box-card">
                <div slot="header" class="clearfix">
                    <span>{{ event.name }}</span>
                </div><br />
                <div>
                    <p>Start Time: {{ event.start_time || 'N/A' }}</p>
                    <p>End Time: {{ event.end_time || 'N/A' }}</p>
                </div>
                <br /><br />
                <el-button @click="getLocation">Make Attendance</el-button>
                <br /><br />
                <!-- <div>{{ locationText }}</div><br />
                <div>{{ errMessage }}</div> -->
            </el-card>
        </div>
        <div v-else>
            <!-- This message will be displayed when isEventDataFetched is false -->
            <el-card class="box-card">
                <p>Event not found...</p>
                <br />
                <p>Please contact to your teacher or TA.</p>
            </el-card>
            <!-- You can customize this message as per your requirement -->
        </div>
    </div>
</template>
  
<script>
import axios from 'axios';
import cookieManager from '../../lib/cookieManager';
import { ElMessageBox, ElLoading } from 'element-plus';


export default {
    name: 'AttendanceTrack',

    data() {
        return {
            event: {},
            accountCredential: '',
            isEventDataFetched: false,
            locationText: '', // Initialize location text
            errMessage: '',
            latitude: 0,
            longitude: 0,
        };
    },

    created() {
        this.accountCredential = cookieManager.getCookie('account_credential');
        this.fetchEventData();
    },

    methods: {
        fetchEventData() {
            console.log(`Authorization Token: Bearer ${this.accountCredential}`);

            axios.get(`/api/current_event/`, {
                headers: {
                    Authorization: `Bearer ${this.accountCredential}`,
                },
            }).then(response => {
                console.log('Event Data Fetched Successfully:', response.data.data[0]);
                this.event = response.data.data[0];
                this.isEventDataFetched = true;
            }).catch(error => {
                console.error('Error fetching event:', error);
            });
        },
        getLocation() {
            console.log("start getting location");
            // Start the loading screen
            const loading = ElLoading.service({
                lock: true,
                text: 'Loading',
                background: 'rgba(0, 0, 0, 0.7)',
            });
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    position => this.showPosition(position, loading),
                    error => this.showError(error, loading)
                );
            } else {
                this.locationText = "Geolocation is not supported by this browser.";
            }
        },
        showPosition(position, loading) {
            this.locationText = `Latitude: ${position.coords.latitude}, Longitude: ${position.coords.longitude}, Accuracy: ${position.coords.accuracy}`;

            const minLat = 24.0; // example min latitude
            const maxLat = 25.0; // example max latitude
            const minLng = 120.0; // example min longitude
            const maxLng = 121.0; // example max longitude

            this.latitude = position.coords.latitude;
            this.longitude = position.coords.longitude;


            // Check if the current position is within the range
            if (this.latitude >= minLat && this.latitude <= maxLat && this.longitude >= minLng && this.longitude <= maxLng) {
                // Call your API if within the range
                this.postAttendance(loading);
            }
        },
        showError(error) {
            switch (error.code) {
                case error.PERMISSION_DENIED:
                    this.errMessage = "User denied the request for Geolocation.";
                    break;
                case error.POSITION_UNAVAILABLE:
                    this.errMessage = "Location information is unavailable.";
                    break;
                case error.TIMEOUT:
                    this.errMessage = "The request to get user location timed out.";
                    break;
                default:
                    this.errMessage = "An unknown error occurred.";
                    break;
            }
        },
        postAttendance(loading) {
            // Use your actual course ID here
            const courseId = this.event.course_id; // Example course ID
            axios.post(`/api/course/${courseId}/attendance`, {
                // Include any required data here
                event_id: this.event.id,
                name: this.event.name,
                latitude: this.latitude,
                longitude: this.longitude,
            }, {
                headers: {
                    Authorization: `Bearer ${this.accountCredential}`,
                }
            })
                .then(response => {
                    // Handle success
                    console.log('Attendance recorded successfully', response.data);
                    ElMessageBox.alert('Attendance recorded successfully', 'Success', {
                        confirmButtonText: 'OK',
                        type: 'success',
                    })
                })
                .catch(error => {
                    // Handle error
                    console.error('Error recording attendance', error);
                    ElMessageBox.alert('Attendance has already recorded', 'Failed', {
                        confirmButtonText: 'OK',
                        type: 'warning',
                    })
                }).finally(() => {
                    loading.close();
                });
        }
    },
};
</script>
  
<style scoped>
/* Add your styles here */
</style>
  ``
  
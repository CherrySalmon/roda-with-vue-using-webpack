<template>
    <div>
        <!-- The card element will only be shown if `isAccountDataFetched` is true -->
        <div v-if="event">
            <el-card class="box-card" style="width: 60%; margin-top: 10%; margin-left: 20%;">
                <div slot="header" class="clearfix">
                    <span>{{ event.name }}</span>
                </div><br />
                <div>
                    <p>Start Time: {{ start_time || 'N/A' }}</p>
                    <p>End Time: {{ end_time || 'N/A' }}</p>
                </div>
                <br /><br />
                <el-button @click="getLocation">Make Attendance</el-button>
                <br /><br />
                <!-- <div>{{ locationText }}</div><br />
                <div>{{ errMessage }}</div> -->
            </el-card>
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
            start_time: '',
            end_time: '',
            accountCredential: '',
            isEventDataFetched: false,
            locationText: '', // Initialize location text
            errMessage: '',
            latitude: 0,
            longitude: 0,
            location: {},
        };
    },
    watch: {
        // Watch the `event` object for changes
        event: {
            handler(newVal) {
                // If event data is still not present after being fetched, redirect
                if ((!newVal || Object.keys(newVal).length === 0) && this.isEventDataFetched) {
                    console.log('No event data found, redirecting...');
                    this.$router.push('/course');
                } else {
                    console.log('Event data found:', newVal);
                }
            },
            deep: true, // This ensures the watcher reacts to changes in object properties
            immediate: true, // This ensures the handler is called immediately with the current value upon creation
        }
    },

    created() {
        this.accountCredential = cookieManager.getCookie('account_credential');
        this.fetchEventData();
    },
    methods: {
        fetchEventData() {
            axios.get(`/api/current_event/`, {
                headers: {
                    Authorization: `Bearer ${this.accountCredential}`,
                },
            }).then(response => {
                console.log('Event Data Fetched Successfully:', response.data.data[0]);
                this.event = response.data.data[0];
                this.isEventDataFetched = true;

                if (this.event) {
                    this.start_time = this.getLocalDateString(this.event.start_time);
                    this.end_time = this.getLocalDateString(this.event.end_time);
                }
            }).catch(error => {
                console.error('Error fetching event:', error);
            });
        },
        getLocalDateString(utcStr) {
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

            this.latitude = position.coords.latitude;
            this.longitude = position.coords.longitude;

            axios.get(`/api/course/${this.event.course_id}/location/${this.event.location_id}`, {
                headers: {
                    Authorization: `Bearer ${this.accountCredential}`,
                },
            }).then(response => {
                console.log('Event Data Fetched Successfully:', response.data.data);
                this.location = response.data.data;
                this.isEventDataFetched = true;
            }).catch(error => {
                console.error('Error fetching event:', error);
            });

            const minLat = this.location.latitude - 0.0004;
            const maxLat = this.location.latitude + 0.0004;
            const minLng = this.location.longitude - 0.0005
            const maxLng = this.location.longitude + 0.0005;

            // Check if the current position is within the range
            if (this.latitude >= minLat && this.latitude <= maxLat && this.longitude >= minLng && this.longitude <= maxLng) {
                // Call your API if within the range
                this.postAttendance(loading);
            } else {
                ElMessageBox.alert('You are not in the right location', 'Failed', {
                    confirmButtonText: 'OK',
                    type: 'error',
                })
                loading.close();
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
                    ElMessageBox.alert('Attendance has already recorded', 'Warning', {
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
  
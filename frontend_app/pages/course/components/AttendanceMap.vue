<template>
    <div id="map" style="height: 600px; width: 100%;"></div>

    <el-table style="width: 100%" :data="enrollments">
        <el-table-column type="index" width="50" />
        <el-table-column width="70">
            <template #default="scope">
                <el-avatar shape="square" :size="40" :src="scope.row.account.avatar" />
            </template>
        </el-table-column>
        <el-table-column prop="account.name" label="Name" width="180" />
        <el-table-column prop="account.email" label="Email" />
        <el-table-column label="Attendance" width="220">
            <template #default="scope">
                <div v-if="eventAttendances.some(attendance => attendance.account_id === scope.row.account.id)">
                    <el-button type="success" disabled>Attendance Recorded</el-button>
                </div>
                <div v-else>
                    <el-button type="info" @click="postAttendance(event, scope.row.account.id)">Mark
                        Attendance</el-button>
                </div>
            </template>
        </el-table-column>
    </el-table>
</template>

<script>
import axios from 'axios'
import cookieManager from '../../../lib/cookieManager';

export default {
    emits: ['closeDialog'],
    props: {
        eventAttendances: Array,
        event: Object,
        enrollments: Object,
    },
    data() {
        return {
        }
    },
    mounted() {
        this.accountCredential = cookieManager.getCookie('account_credential');
        this.initMap();
    },
    methods: {
        async loadGoogleMapsApi() {
            if (typeof google === "undefined" || typeof google.maps === "undefined") {
                const script = document.createElement('script');
                script.src = `https://maps.googleapis.com/maps/api/js?key=${process.env.VUE_APP_GOOGLE_MAP_KEY}`;
                document.head.appendChild(script);
                await new Promise((resolve) => {
                    script.onload = resolve;
                });
            }
        },
        async initMap() {
            await this.loadGoogleMapsApi();

            const center = {
                lat: this.event.latitude,
                lng: this.event.longitude,
            };

            const map = new google.maps.Map(document.getElementById("map"), {
                zoom: 18,
                center: center,
                mapId: '82dda74d2d05b087'
            });

            this.eventAttendances.forEach(attendance => {
                new google.maps.Marker({
                    position: { lat: attendance.latitude, lng: attendance.longitude },
                    map: map,
                    title: attendance.name,
                });
            });
        },
        postAttendance(event, accountId) {
            console.log('Posting attendance', event, accountId);
            const courseId = event.course_id;
            axios.post(`/api/course/${courseId}/attendance`, {
                account_id: accountId,
                event_id: event.id,
                name: event.name,
            }, {
                headers: {
                    Authorization: `Bearer ${this.accountCredential}`,
                }
            })
                .then(response => {
                    console.log('Attendance recorded successfully', response.data);
                    this.$emit('closeDialog');
                    ElMessageBox.alert('Attendance recorded successfully', 'Success', {
                        confirmButtonText: 'OK',
                        type: 'success',
                    })
                })
                .catch(error => {
                    console.error('Error recording attendance', error);
                    this.$emit('closeDialog');
                    ElMessageBox.alert('Fail to record attendance', 'Warning', {
                        confirmButtonText: 'OK',
                        type: 'warning',
                    })
                });
        }
    }
}
</script>
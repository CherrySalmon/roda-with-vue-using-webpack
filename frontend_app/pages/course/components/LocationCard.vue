<template>
    <div style="margin: 20px 40px;">
        <div v-for="location in locations" :key="location.value">{{ location.value }}: {{ location.label }}</div>
        <div class="form-container">
            <h1 style="margin-bottom: 10px;">Create new Location</h1>
            <el-form ref="locationForm" :model="locationForm" label-width="80px">
                <el-form-item label="Name">
                    <el-input v-model="locationForm.name"></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="submitLocation">Submit Location</el-button>
                </el-form-item>
            </el-form>
        </div>
        
    </div>
</template>
  
<script>
  export default {
    emits: ['create-location'],
    props: {
        locations: Array
    },
    data() {
        return {
            locationForm: {
                name: '',
                latitude: '',
                longitude: ''
            }
        }
    },
    watch: {

    },
    methods: {
        getLocation() {
            // Check if Geolocation is supported
            if ("geolocation" in navigator) {
                navigator.geolocation.getCurrentPosition((position) => {
                    const { latitude, longitude } = position.coords
                    const locationData = {
                        name: this.locationForm.name,
                        latitude: latitude,
                        longitude: longitude
                    };
                    this.$emit('create-location', locationData)
                    this.resetForm()
                }, (error) => {
                    // Handle location 
                    console.error('Error getting location', error);
                });
            } else {
                // Geolocation is not supported by this browser
                console.error('Geolocation is not supported by this browser.');
            }
        },
        submitLocation() {
            if (this.locationForm.name.trim() === '') {
                alert('Please enter a location name.');
                return;
            }
            this.getLocation(); // Get location coords then create new location
        },
        resetForm() {
            this.locationForm = { name: '', latitude: '', longitude: '' };
        }
    }
}
</script>
<style scoped>
.form-container {
    width: 400px;
    margin: 30px 20px;
}

</style>
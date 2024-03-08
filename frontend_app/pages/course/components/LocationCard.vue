<template>
    <div style="margin: 20px 40px;">
        <div v-for="location in locations" :key="location.value" class="location-item">
            {{ location.value }}: {{ location.label }}
            <el-icon :size="14" @click.stop="$emit('delete-location', location.value)" class="location-icon">
                <Close />
            </el-icon>
        </div>

        <div class="form-container">
            <h1 style="margin-bottom: 10px;">Create new Location</h1>
            <el-form ref="locationForm" :model="locationForm" label-width="80px">
                <el-form-item label="Name">
                    <el-input placeholder="Enter a name of the location" v-model="locationForm.name"></el-input>
                </el-form-item>
                <!-- <el-form-item>
                    <el-button type="primary" @click="submitLocation">Submit Location</el-button>
                    <p style="font-size: small; color: darkgrey;">( Your current location will be used )</p>
                </el-form-item> -->
                <div id="map" style="height: 400px; width: 150%"></div>
            </el-form>
        </div>

    </div>
</template>
  
<script>
export default {
    emits: ['create-location', 'delete-location'],
    props: {
        locations: Array,
        currentLocationData:{
            type: Object,
            default: () => ({})
        }
    },
    name: 'GoogleMapComponent',

    async mounted() {
        await this.loadGoogleMapsApi();
        this.initMap();
    },

    data() {
        return {
            locationForm: {
                name: '',
                latitude: '',
                longitude: ''
            },
            locationData: {}
        }
    },
    watch: {

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

        initMap() {
            // Assuming google.maps has been loaded in the global scope
            // You might need to handle loading the Google Maps script if it's not already loaded
            const myLatlng = { lat: this.currentLocationData.latitude, lng: this.currentLocationData.longitude };
            const map = new google.maps.Map(document.getElementById("map"), {
                zoom: 16,
                center: myLatlng,
            });

            // Create the initial InfoWindow.
            let infoWindow = new google.maps.InfoWindow({
                content: "Click the map to get Lat/Lng!",
                position: myLatlng,
            });

            infoWindow.open(map);

            // Configure the click listener.
            map.addListener("click", (mapsMouseEvent) => {
                const latLng = mapsMouseEvent.latLng.toJSON();

                // Close the current InfoWindow.
                infoWindow.close();

                const contentString =
                    `<div style="text-align: center;">
                        <p style="margin: 10px 15px 5px;">Latitude: ${latLng.lat}</p>
                        <p style="margin-bottom: 10px;">Longitude: ${latLng.lng}</p>
                        <button id="saveLocationBtn" class="info-button">Save Location</button>
                    </div>`;

                // Create a new InfoWindow.
                infoWindow = new google.maps.InfoWindow({
                    position: mapsMouseEvent.latLng,
                    content: contentString,
                });
                // infoWindow.setContent(
                //     JSON.stringify(mapsMouseEvent.latLng.toJSON(), null, 2),
                // );
                infoWindow.addListener('domready', () => {
                    document.getElementById("saveLocationBtn").addEventListener("click", () => {
                        this.saveLocation(latLng);
                    });
                });
                infoWindow.open(map);
            });
        },
        saveLocation(latLng) {
            const locationData = {
                name: this.locationForm.name, // Use the name from the form
                latitude: latLng.lat,
                longitude: latLng.lng
            };
            this.$emit('create-location', locationData);
            // Optionally reset the form or infoWindow here
        },
    }
}
</script>
<style scoped>
.form-container {
    width: 400px;
    margin: 30px 20px;
}

.location-item {
    display: flex;
    align-items: center;
    /* Ensures vertical alignment in case icon and text have different heights */
}

.location-icon {
    cursor: pointer;
    /* Changes the cursor to a pointer when hovering over the icon */
    margin-left: 5px;
    /* Optional: Adds a small space between the text and the icon */
}
</style>
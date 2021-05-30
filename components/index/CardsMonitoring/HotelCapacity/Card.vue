<template>
  <v-col id="HotelCapacityCard" cols="12" :md="md" class="DataCard">
    <client-only>
      <hotel-capacity-beds
        :title="$t('HotelCapacityCard.title')"
        title-id="hotel-capacity"
        :date="date"
        :bed-summary="bedSummary"
      />
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import dayjs from 'dayjs'
import Vue from 'vue'

import HotelCapacityBeds from '@/components/index/CardsMonitoring/HotelCapacity/Beds.vue'
import MainSummary from '@/data/main_summary.json'
import PositiveStatus from '@/data/positive_status.json'

export default Vue.extend({
  components: {
    HotelCapacityBeds,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const date = dayjs(PositiveStatus.date).format('YYYY/MM/DD HH:mm')
    const hotel = MainSummary.宿泊療養
    const maxBeds = hotel > 300 ? hotel : 300
    const beds = [...Array(maxBeds).keys()]
    const bedSummary = {
      beds,
      maxBeds,
      hotel,
    }
    return {
      date,
      bedSummary,
    }
  },
})
</script>

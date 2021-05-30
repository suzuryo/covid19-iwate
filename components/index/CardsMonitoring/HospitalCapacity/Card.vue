<template>
  <v-col id="HospitalCapacityCard" cols="12" :md="md" class="DataCard">
    <client-only>
      <hospital-capacity-beds
        :title="$t('HospitalCapacityCard.title')"
        title-id="hospital-capacity"
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

import HospitalCapacityBeds from '@/components/index/CardsMonitoring/HospitalCapacity/Beds.vue'
import MainSummary from '@/data/main_summary.json'
import PositiveStatus from '@/data/positive_status.json'

export default Vue.extend({
  components: {
    HospitalCapacityBeds,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const date = dayjs(PositiveStatus.date).format('YYYY/MM/DD HH:mm')
    const hospital = MainSummary.入院
    const waiting = MainSummary.調整中
    const maxBeds = hospital + waiting > 350 ? hospital + waiting : 350
    const beds = [...Array(maxBeds).keys()]
    const bedSummary = {
      beds,
      maxBeds,
      hospital,
      waiting,
    }
    return {
      date,
      bedSummary,
    }
  },
})
</script>

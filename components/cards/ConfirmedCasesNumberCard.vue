<template>
  <v-col id="ConfirmedCasesNumberCard" cols="12" :md="md" class="DataCard">
    <client-only>
      <time-bar-chart
        :title="$t('ConfirmedCasesNumberCard.title')"
        :title-id="'number-of-confirmed-cases'"
        :chart-id="'time-bar-chart-patients'"
        :chart-data="patientsGraph"
        :date="Data.patients_summary.date"
        :unit="$t('Common.人')"
        :by-date="true"
      />
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import TimeBarChart from '@/components/TimeBarChart.vue'
import Data from '@/data/data.json'
import formatGraph from '@/utils/formatGraph'

export default {
  components: {
    TimeBarChart,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    // 感染者数グラフ
    const patientsGraph = formatGraph(Data.patients_summary.data)

    return {
      Data,
      patientsGraph,
    }
  },
}
</script>

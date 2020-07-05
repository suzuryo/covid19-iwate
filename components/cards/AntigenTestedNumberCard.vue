<template>
  <v-col cols="12" md="6" class="DataCard">
    <time-bar-chart
      :title="$t('抗原検査件数')"
      :title-id="'number-of-antigen-tested'"
      :chart-id="'antigen-tested-time-bar-chart'"
      :chart-data="antigenTestsGraph"
      :date="Data.antigen_tests_summary.date"
      :unit="$t('件.tested')"
    />
    <!-- 件.reports = 抗原検査件数 -->
  </v-col>
</template>

<script>
import Data from '@/data/data.antigen_tests_summary.json'
import formatGraph from '@/utils/formatGraph'
import TimeBarChart from '@/components/TimeBarChart.vue'

export default {
  components: {
    TimeBarChart
  },
  data() {
    // 抗原検査件数
    const antigenTestsGraph = formatGraph(Data.antigen_tests_summary.data)

    const data = {
      Data,
      antigenTestsGraph
    }
    return data
  }
}
</script>

<template>
  <v-col cols="12" md="6" class="DataCard">
    <time-stacked-bar-chart-antigen-tests
      :title="$t('抗原検査件数')"
      :title-id="'antigen-tests-summary'"
      :chart-id="'antigen-tests-time-stacked-bar-chart'"
      :chart-data="antigenTestsGraph"
      :date="Data.antigen_tests_summary.date"
      :items="antigenTestsItems"
      :labels="antigenTestsLabels"
      :unit="$t('件.tested')"
      :data-labels="antigenTestsDataLabels"
    >
      <!-- 件.tested = 検査数 -->
    </time-stacked-bar-chart-antigen-tests>
  </v-col>
</template>

<script>
import dayjs from 'dayjs'
import duration from 'dayjs/plugin/duration'
import Data from '@/data/data.antigen_tests_summary.json'
import TimeStackedBarChartAntigenTests from '@/components/TimeStackedBarChartAntigenTests.vue'
dayjs.extend(duration)

export default {
  components: {
    TimeStackedBarChartAntigenTests
  },
  data() {
    // 検査実施日別状況
    const antigenTestsGraph = [Data.antigen_tests_summary.data['抗原検査件数']]
    const antigenTestsItems = [this.$t('抗原検査件数')]
    const antigenTestsLabels = Data.antigen_tests_summary.labels
    const antigenTestsDataLabels = [this.$t('抗原検査件数')]

    const data = {
      Data,
      antigenTestsGraph,
      antigenTestsItems,
      antigenTestsLabels,
      antigenTestsDataLabels
    }
    return data
  }
}
</script>

<style module lang="scss">
.Graph {
  &Desc {
    margin: 0;
    margin-top: 1rem;
    padding-left: 0 !important;
    font-size: 12px;
    color: $gray-3;
    list-style: none;
  }
}
</style>

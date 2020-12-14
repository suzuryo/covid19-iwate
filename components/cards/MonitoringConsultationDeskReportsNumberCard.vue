<template>
  <v-col cols="12" md="6" class="DataCard">
    <client-only>
      <time-bar-chart
        :title="$t('受診・相談センター 受付件数')"
        title-id="monitoring-number-of-reports-to-covid19-consultation-desk"
        chart-id="monitoring-consultation-desk-report-chart"
        :chart-data="querentsGraph"
        :date="Data.querents.date"
        :unit="$t('件.reports')"
      >
        <template #additionalDescription>
          <span>{{ $t('（注）') }}</span>
          <ul>
            <li>
              {{ $t('主に「症状がある方からの受診等に関する相談」を計上') }}
            </li>
            <li>
              {{ $t('コールセンター・各保健所等への受付件数の合計') }}
            </li>
            <li>
              {{ $t('窓口を開設した2020年2月8日からのデータを表示') }}
            </li>
          </ul>
        </template>
      </time-bar-chart>
    </client-only>
  </v-col>
</template>

<script>
import Data from '@/data/data.json'
import formatGraph from '@/utils/formatGraph'
import TimeBarChart from '@/components/TimeBarChart.vue'

export default {
  components: {
    TimeBarChart,
  },
  data() {
    // 相談件数
    const querentsGraph = formatGraph(Data.querents.data)

    return {
      Data,
      querentsGraph,
    }
  },
}
</script>

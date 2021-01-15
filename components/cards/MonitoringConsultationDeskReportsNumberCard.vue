<template>
  <v-col
    id="MonitoringConsultationDeskReportsNumberCard"
    cols="12"
    :md="md"
    class="DataCard"
  >
    <client-only>
      <time-bar-chart
        :title="$t('受診・相談センター 受付件数')"
        title-id="monitoring-number-of-reports-to-covid19-consultation-desk"
        chart-id="monitoring-consultation-desk-report-chart"
        :chart-data="querentsGraph"
        :date="Data.querents.date"
        :unit="$t('件.reports')"
      >
        <template #notes>
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
            <li>
              {{ $t('岩手県の発表漏れによりデータの存在しない日がある') }}
            </li>
          </ul>
        </template>
      </time-bar-chart>
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
    // 相談件数
    const querentsGraph = formatGraph(Data.querents.data)

    return {
      Data,
      querentsGraph,
    }
  },
}
</script>

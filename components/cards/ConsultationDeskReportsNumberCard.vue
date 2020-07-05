<template>
  <v-col cols="12" md="6" class="DataCard">
    <time-bar-chart
      :title="$t('（一般相談）受付 相談件数')"
      :title-id="'number-of-reports-to-covid19-consultation-desk'"
      :chart-id="'time-bar-chart-querents'"
      :chart-data="querentsGraph"
      :date="Data.querents.date"
      :unit="$t('件.reports')"
    >
      <template v-slot:description>
        <ul>
          <li>
            {{ $t('（注）開設日 令和2年1月21日') }}
          </li>
          <li>
            {{ $t('（注）各保健所・医療政策室への受付件数の合計') }}
          </li>
          <li>
            {{
              $t(
                '（注）「新型コロナウイルス感染症に関する疑問や心配事がある方からの一般相談」を計上 '
              )
            }}
          </li>
        </ul>
      </template>
    </time-bar-chart>
    <!-- 件.reports = 窓口相談件数 -->
  </v-col>
</template>

<script>
import Data from '@/data/data.querents.json'
import formatGraph from '@/utils/formatGraph'
import TimeBarChart from '@/components/TimeBarChart.vue'

export default {
  components: {
    TimeBarChart
  },
  data() {
    // 帰国者・接触者 電話相談センター 相談件数
    const querentsGraph = formatGraph(Data.querents.data)

    const data = {
      Data,
      querentsGraph
    }
    return data
  }
}
</script>

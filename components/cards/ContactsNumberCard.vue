<template>
  <v-col cols="12" md="6" class="DataCard">
    <time-bar-chart
      :title="$t('（帰国者・接触者相談センター）受付 相談件数')"
      :title-id="'number-of-reports-to-covid19-telephone-advisory-center'"
      :chart-id="'time-bar-chart-contacts'"
      :chart-data="contactsGraph"
      :date="Data.contacts.date"
      :unit="$t('件.reports')"
    >
      <template v-slot:description>
        <ul>
          <li>
            {{ $t('（注）開設日 令和2年2月8日') }}
          </li>
          <li>
            {{ $t('（注）各保健所・医療政策室への受付件数の合計') }}
          </li>
          <li>
            {{
              $t('（注）主に「症状がある方からの受診等に関する相談」を計上 ')
            }}
          </li>
        </ul>
      </template>
    </time-bar-chart>
    <!-- 件.reports = 窓口相談件数 -->
  </v-col>
</template>

<script>
import Data from '@/data/data.contacts.json'
import formatGraph from '@/utils/formatGraph'
import TimeBarChart from '@/components/TimeBarChart.vue'

export default {
  components: {
    TimeBarChart
  },
  data() {
    // 相談件数
    const contactsGraph = formatGraph(Data.contacts.data)

    const data = {
      Data,
      contactsGraph
    }
    return data
  }
}
</script>

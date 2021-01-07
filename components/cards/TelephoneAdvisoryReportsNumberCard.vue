<template>
  <v-col
    id="TelephoneAdvisoryReportsNumberCard"
    cols="12"
    md="6"
    class="DataCard"
  >
    <client-only>
      <time-bar-chart
        :title="$t('一般相談 受付件数')"
        :title-id="'number-of-reports-to-covid19-telephone-advisory-center'"
        :chart-id="'time-bar-chart-contacts'"
        :chart-data="contactsGraph"
        :date="Data.contacts.date"
        :unit="$t('件.reports')"
      >
        <!-- 件.reports = 窓口相談件数 -->
        <template #notes>
          <ul>
            <li>
              {{
                $t(
                  '「新型コロナウイルス感染症に関する疑問や心配事がある方からの一般相談」を計上'
                )
              }}
            </li>
            <li>
              {{ $t('コールセンター・各保健所等への受付件数の合計') }}
            </li>
            <li>
              {{ $t('窓口を開設した2020年1月21日からのデータを表示') }}
            </li>
            <li>
              {{ $t('岩手県の発表漏れによりデータの存在しない日がある') }}
            </li>
          </ul>
        </template>
      </time-bar-chart>
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
  data() {
    // 相談件数
    const contactsGraph = formatGraph(Data.contacts.data)

    return {
      Data,
      contactsGraph,
    }
  },
}
</script>

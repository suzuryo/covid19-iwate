<template>
  <v-col cols="12" md="6" class="DataCard">
    <client-only>
      <untracked-rate-mixed-chart
        :title-id="'untracked-rate'"
        :info-titles="[$t('接触歴等不明者数(7日間移動平均)'), $t('前週比')]"
        :chart-id="'untracked-rate-chart'"
        :chart-data="graphData"
        :get-formatter="getFormatter"
        :date="updated"
        :labels="dateList"
        :unit="[$t('Common.人'), '%']"
        :data-labels="dataLabels"
        :table-labels="tableLabels"
      >
        <template #additionalDescription>
          <span>{{ $t('Common.注') }}</span>
          <ul>
            <li>
              {{
                $t(
                  '新規陽性者について、公表日時点の接触歴等の不明者、判明者に区分したものである'
                )
              }}
            </li>
            <li>
              {{
                $t(
                  '公表時点での接触歴の有無であり、公表後の追加調査で判明する場合があるが、それは反映されていない'
                )
              }}
            </li>
            <li>
              {{ $t('Common.7MA') }}
            </li>
            <li>
              {{
                $t(
                  '前週比は１週間前の接触歴等不明者数（移動平均値）との比較、サンプル数が少ないので断続的'
                )
              }}
            </li>
          </ul>
        </template>
      </untracked-rate-mixed-chart>
    </client-only>
  </v-col>
</template>

<script>
import Data from '@/data/daily_positive_detail.json'
import UntrackedRateMixedChart from '@/components/UntrackedRateMixedChart'
import {
  getNumberToFixedFunction,
  getNumberToLocaleStringFunction,
} from '@/utils/monitoringStatusValueFormatters'

export default {
  components: {
    UntrackedRateMixedChart,
  },
  data() {
    const data = Data.data.filter(
      (d) => new Date(d.diagnosed_date) >= new Date('2020-03-27')
    )
    const reportedCount = data.map((d) => d.reported_count)
    const missingCount = data.map((d) => d.missing_count)
    const untrackedRate = data.map((d) => d.weekly_average_untracked_count)
    const untrackedIncreseRate = data.map(
      (d) => d.weekly_average_untracked_increse_percent
    )
    const dateList = data.map((d) => d.diagnosed_date)
    const updated = Data.date
    const graphData = [
      reportedCount,
      missingCount,
      untrackedRate,
      untrackedIncreseRate,
    ]

    const dataLabels = [
      this.$t('接触歴等判明者数'),
      this.$t('接触歴等不明者数'),
      this.$t('接触歴等不明者数（７日間移動平均）'),
      this.$t('前週比'),
    ]
    const tableLabels = [
      this.$t('接触歴等判明者数'),
      this.$t('接触歴等不明者数'),
      this.$t('接触歴等不明者数（７日間移動平均）'),
      this.$t('前週比'),
    ]

    const getFormatter = (columnIndex) => {
      // 7日間移動平均と前週比は小数点第1位まで表示する。
      if (columnIndex >= 2) {
        return getNumberToFixedFunction(1)
      }
      return getNumberToLocaleStringFunction()
    }

    return {
      updated,
      graphData,
      dateList,
      dataLabels,
      tableLabels,
      getFormatter,
    }
  },
}
</script>

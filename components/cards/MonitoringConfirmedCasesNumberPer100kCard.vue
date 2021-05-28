<template>
  <v-col
    id="MonitoringConfirmedCasesNumberPer100kCard"
    cols="12"
    md="12"
    class="DataCard"
  >
    <client-only>
      <monitoring-confirmed-cases-chart-per-100k
        title-id="monitoring-number-of-confirmed-cases-per-100k"
        :info-titles="[$t('MonitoringConfirmedCasesNumberPer100kCard.title')]"
        chart-id="monitoring-confirmed-cases-chart"
        :chart-data="chartData"
        :get-formatter="getFormatter"
        :date="date"
        :labels="labels"
        :data-labels="dataLabels"
        :table-labels="tableLabels"
        :unit="$t('Common.人')"
      >
        <template #notes>
          <ul>
            <li
              v-for="(note, i) in $t(
                'MonitoringConfirmedCasesNumberPer100kCard.notes'
              )"
              :key="i"
            >
              {{ note }}
            </li>
          </ul>
        </template>
      </monitoring-confirmed-cases-chart-per-100k>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import MonitoringConfirmedCasesChartPer100k from '@/components/MonitoringConfirmedCasesChartPer100k.vue'
import DailyPositiveDetail from '@/data/daily_positive_detail.json'
import Data from '@/data/data.json'
import {
  getNumberToFixedFunction,
  getNumberToLocaleStringFunction,
} from '@/utils/monitoringStatusValueFormatters'

export default {
  components: {
    MonitoringConfirmedCasesChartPer100k,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    // 扱う日付の配列
    const labels = DailyPositiveDetail.data.map((a) => a.diagnosed_date)

    // 盛岡市の陽性者データ
    const patients = Data.patients.data.filter((a) => a.居住地 === '盛岡市')

    // labelの配列項目の日付に対応する、その日の盛岡市の感染者の数
    const patientsCount = labels.map((a) => {
      return patients.filter((b) => b.確定日 === a).length
    })

    // 1週間あたり10万人あたりの陽性者数
    const sevenDayMoveAveragesPer10k = []
    labels.forEach((_currentValue, index, _array) => {
      const i = index - 6 < 0 ? 0 : index - 6
      const p = patientsCount.slice(i, index + 1)
      sevenDayMoveAveragesPer10k.push(
        // 盛岡市の人口を 291320 人 とする
        (p.reduce((a, b) => a + b, 0) * 100000) / 291320
      )
    })

    const chartData = [patientsCount, sevenDayMoveAveragesPer10k]
    const dataLabels = [
      this.$t('MonitoringConfirmedCasesNumberPer100kCard.legends[0]'),
      this.$t('MonitoringConfirmedCasesNumberPer100kCard.legends[1]'),
    ]
    const tableLabels = [
      this.$t('MonitoringConfirmedCasesNumberPer100kCard.legends[0]'),
      this.$t('MonitoringConfirmedCasesNumberPer100kCard.legends[1]'),
    ]
    const date = DailyPositiveDetail.date

    const getFormatter = (columnIndex) => {
      // 新規陽性者数の7日間移動平均は小数点第1位まで表示する。
      if (columnIndex === 1) {
        return getNumberToFixedFunction(1)
      }
      return getNumberToLocaleStringFunction()
    }

    return {
      chartData,
      date,
      labels,
      dataLabels,
      tableLabels,
      getFormatter,
    }
  },
}
</script>

<!--<style lang="scss" module>-->
<!--</style>-->

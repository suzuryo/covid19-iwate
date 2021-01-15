<template>
  <v-col
    id="MonitoringConfirmedCasesNumberCard"
    cols="12"
    :md="md"
    class="DataCard"
  >
    <client-only>
      <monitoring-confirmed-cases-chart
        title-id="monitoring-number-of-confirmed-cases"
        :info-titles="[
          $t('ConfirmedCasesNumberCard.title[0]'),
          $t('ConfirmedCasesNumberCard.title[1]'),
        ]"
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
            <li>
              {{ $t('Common.検査結果の判明日を基準とする') }}
            </li>
            <li v-for="(item, i) in $t('ConfirmedCasesNumberCard.a')" :key="i">
              {{ item }}
            </li>
            <li>
              {{ $t('Common.7MA') }}
            </li>
          </ul>
          <div :class="$style.newScenario">
            <hr />
            <div :class="$style.newScenarioSummarry">
              <p v-for="(item, i) in $t('ConfirmedCasesNumberCard.b')" :key="i">
                {{ item }}
              </p>
            </div>
            <div :class="$style.newScenarioExternalLink">
              <div>
                <app-link :to="$t('ExtLink.岩手県17_2.url')">
                  {{ $t('ExtLink.岩手県17_2.text') }}
                </app-link>
              </div>
              <div>
                <app-link :to="$t('ExtLink.厚生労働省x696.url')">
                  {{ $t('ExtLink.厚生労働省x696.text') }}
                </app-link>
              </div>
            </div>
          </div>
        </template>
      </monitoring-confirmed-cases-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import AppLink from '@/components/AppLink.vue'
import MonitoringConfirmedCasesChart from '@/components/MonitoringConfirmedCasesChart.vue'
import Data from '@/data/daily_positive_detail.json'
import {
  getNumberToFixedFunction,
  getNumberToLocaleStringFunction,
} from '@/utils/monitoringStatusValueFormatters'

export default {
  components: {
    MonitoringConfirmedCasesChart,
    AppLink,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const [patientsCount, sevenDayMoveAverages, labels] = Data.data.reduce(
      (res, data) => {
        res[0].push(data.count)
        res[1].push(data.weekly_average_count)
        res[2].push(data.diagnosed_date)
        return res
      },
      [[], [], []]
    )
    const chartData = [patientsCount, sevenDayMoveAverages]
    const dataLabels = [
      this.$t('Common.陽性者数'),
      this.$t('Common.７日間移動平均'),
    ]
    const tableLabels = [
      this.$t('Common.陽性者数'),
      this.$t('Common.７日間移動平均'),
    ]
    const date = Data.date

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

<style lang="scss" module>
.newScenario {
  hr {
    border-top: none;
    border-right: none;
    border-bottom: 1px solid $gray-4;
    border-left: none;
    margin-top: 20px;
    margin-bottom: 20px;
  }
  .newScenarioExternalLink {
    margin-bottom: 10px;
    text-align: right;
  }
  .newScenarioSummarry {
    color: red;
  }
}
</style>

<template>
  <v-col id="PositiveRateCard" cols="12" md="6" class="DataCard">
    <client-only>
      <positive-rate-mixed-chart
        :title-id="'positive-rate'"
        :info-titles="[
          $t('PositiveRateCard.a[0]'),
          $t('PositiveRateCard.a[1]'),
        ]"
        :chart-id="'positive-rate-chart'"
        :chart-data="positiveRateGraph"
        :get-formatter="getFormatter"
        :date="PositiveRate.date"
        :labels="positiveRateLabels"
        unit="%"
        :option-unit="$t('件.reports')"
        :data-labels="positiveRateDataLabels"
        :table-labels="positiveRateTableLabels"
      >
        <template #notes>
          <div :class="$style.newScenario">
            <ul>
              <li>
                {{ $t('PositiveRateCard.b[0]') }}
              </li>
              <li>
                {{ $t('Common.7MA') }}
              </li>
              <li>
                {{ $t('Common.検査結果の判明日を基準とする') }}
              </li>
              <li>
                {{ $t('PositiveRateCard.b[1]') }}
              </li>
            </ul>
            <hr />
            <div :class="$style.newScenarioSummarry">
              <p>
                <strong>
                  {{ $t('PositiveRateCard.c[0]') }}
                </strong>
              </p>
              <p>
                {{ $t('PositiveRateCard.c[1]') }}
              </p>
            </div>
            <div :class="$style.newScenarioExternalLink">
              <div>
                <app-link :to="$t('ExtLink.岩手県17_2.url')">
                  {{ $t('ExtLink.岩手県17_2.text') }}
                </app-link>
              </div>
            </div>
          </div>
        </template>
      </positive-rate-mixed-chart>
    </client-only>
  </v-col>
</template>

<script>
import dayjs from 'dayjs'
import duration from 'dayjs/plugin/duration'
import PositiveRate from '@/data/positive_rate.json'
import PositiveRateMixedChart from '@/components/PositiveRateMixedChart'
import {
  getNumberToFixedFunction,
  getNumberToLocaleStringFunction,
  getCommaSeparatedNumberToFixedFunction,
} from '@/utils/monitoringStatusValueFormatters'
import AppLink from '@/components/AppLink.vue'
dayjs.extend(duration)

export default {
  components: {
    PositiveRateMixedChart,
    AppLink,
  },
  data() {
    // 検査実施日別状況
    const { data } = PositiveRate
    const pcrPositiveCount = data.map((data) => data.pcr_positive_count)
    const pcrNegativeCount = data.map((data) => data.pcr_negative_count)
    const antigenPositiveCount = data.map((data) => data.antigen_positive_count)
    const antigenNegativeCount = data.map((data) => data.antigen_negative_count)
    const positiveRates = data.map((data) => data.positive_rate)
    const positiveRateLabels = data.map((data) => data.diagnosed_date)
    const weeklyAverageDiagnosedCount = data.map(
      (data) => data.weekly_average_diagnosed_count
    )
    const positiveRateGraph = [
      pcrPositiveCount,
      antigenPositiveCount,
      pcrNegativeCount,
      antigenNegativeCount,
      weeklyAverageDiagnosedCount,
      positiveRates,
    ]
    const positiveRateDataLabels = [
      this.$t('PositiveRateCard.a[2]'),
      this.$t('PositiveRateCard.a[3]'),
      this.$t('PositiveRateCard.a[4]'),
      this.$t('PositiveRateCard.a[5]'),
      this.$t('PositiveRateCard.a[6]'),
      this.$t('PositiveRateCard.a[7]'),
    ]
    const positiveRateTableLabels = positiveRateDataLabels.map((d) => d)

    const getFormatter = (columnIndex) => {
      if (columnIndex === 4) {
        // 検査件数（７日間移動平均）は小数点第1位まで表示し、整数部分は３桁区切りにする。
        return getCommaSeparatedNumberToFixedFunction(1)
      } else if (columnIndex === 5) {
        // 陽性率は小数点第1位まで表示する。
        return getNumberToFixedFunction(1)
      } else {
        return getNumberToLocaleStringFunction()
      }
    }

    return {
      PositiveRate,
      positiveRateGraph,
      positiveRateLabels,
      positiveRateDataLabels,
      positiveRateTableLabels,
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

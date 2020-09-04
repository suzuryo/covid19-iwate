<template>
  <v-col cols="12" md="6" class="DataCard">
    <client-only>
      <positive-rate-mixed-chart
        :title-id="'positive-rate'"
        :info-titles="[$t('検査の陽性率'), $t('PCR検査の7日間移動平均')]"
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
        <template v-slot:additionalDescription>
          <div :class="$style.newScenario">
            <span>{{ $t('（注）') }}</span>
            <ul>
              <li>
                {{
                  $t(
                    '陽性率：陽性判明数（PCR・抗原）の移動平均／検査件数（＝陽性判明数（PCR・抗原）＋陰性判明数（PCR・抗原））の移動平均'
                  )
                }}
              </li>
              <li>
                {{
                  $t(
                    '集団感染発生や曜日による数値のばらつきにより、日々の結果が変動するため、こうしたばらつきを平準化し全体の傾向を見る趣旨から、過去7日間の移動平均値をもとに算出し、折れ線グラフで示す（例えば、8月7日の陽性率は、8月1日から8月7日までの実績平均を用いて算出）'
                  )
                }}
              </li>
              <li>
                {{ $t('検査結果の判明日を基準とする') }}
              </li>
              <li>
                {{
                  $t(
                    '速報値として公表するものであり、後日確定データとして修正される場合がある'
                  )
                }}
              </li>
            </ul>
            <hr />
            <div :class="$style.newScenarioSummarry">
              <p>
                <strong>
                  {{ $t('岩手県の1日あたりの検査可能件数は864件') }}
                </strong>
              </p>
              <p>
                {{
                  $t(
                    '感染ピーク時の1日あたりの検査件数は、陽性率 10.4% と想定すると、実効再生産数 R1.7 の場合は 444 件、実効再生産数 R2.0 の場合は 829件 として検査態勢を整備している。'
                  )
                }}
              </p>
            </div>
            <div :class="$style.newScenarioExternalLink">
              <div>
                <external-link
                  url="https://www.pref.iwate.jp/_res/projects/default_project/_page_/001/028/231/20200710_03.pdf#page=5"
                >
                  {{ $t('岩手県 / 第17回本部員会議資料【資料2】[PDF]') }}
                </external-link>
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
import ExternalLink from '@/components/ExternalLink'
dayjs.extend(duration)

export default {
  components: {
    PositiveRateMixedChart,
    ExternalLink,
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
      this.$t('PCR検査陽性者数'),
      this.$t('抗原検査陽性者数'),
      this.$t('PCR検査陰性者数'),
      this.$t('抗原検査陰性者数'),
      this.$t('検査件数（７日間移動平均）'),
      this.$t('陽性率'),
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

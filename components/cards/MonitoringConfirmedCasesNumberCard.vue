<template>
  <v-col cols="12" md="6" class="DataCard">
    <client-only>
      <monitoring-confirmed-cases-chart
        title-id="monitoring-number-of-confirmed-cases"
        :info-titles="[$t('新規陽性者数の7日間平均')]"
        chart-id="monitoring-confirmed-cases-chart"
        :chart-data="chartData"
        :get-formatter="getFormatter"
        :date="date"
        :labels="labels"
        :data-labels="dataLabels"
        :table-labels="tableLabels"
        :unit="$t('人')"
        url="https://catalog.data.metro.tokyo.lg.jp/dataset/t000010d0000000068"
      >
        <template v-slot:additionalDescription>
          <div :class="$style.newScenario">
            <span>{{ $t('（注）') }}</span>
            <ul>
              <li>
                {{ $t('保健所から発生届が提出された日を基準とする') }}
              </li>
              <li>
                {{ $t('医療機関等が行った検査も含む') }}
              </li>
              <li>
                {{
                  $t(
                    '集団感染発生や曜日による数値のばらつきにより、日々の結果が変動するため、こうしたばらつきを平準化し全体の傾向を見る趣旨から、過去7日間の移動平均値を折れ線グラフで示す（例えば、8月7日の移動平均値は、8月1日から8月7日までの実績値を平均したもの）'
                  )
                }}
              </li>
            </ul>
            <hr />
            <div :class="$style.newScenarioSummarry">
              <p>
                {{ $t('岩手県の場合、') }}
                <strong>
                  {{
                    $t(
                      '陽性者数が4.4人/日 (31人/週) (実効再生産数 R1.7) の状態が 3日間 続いたら、社会への協力要請'
                    )
                  }}
                </strong>
                {{
                  $t(
                    '（外出自粛要請、営業自粛要請、学校の休校等）をおこない、その20日後に入院患者数のピークが266人となり、計画している病床数 (フェーズ3にて軽中症305床) に収まるという「新たな流行シナリオ」に基づいて医療提供体制等を整備している'
                  )
                }}
              </p>
            </div>
            <div :class="$style.newScenarioExternalLink">
              <div>
                <external-link
                  url="https://www.pref.iwate.jp/_res/projects/default_project/_page_/001/028/231/20200710_03.pdf"
                >
                  {{ $t('岩手県 / 第17回本部員会議資料【資料2】[PDF]') }}
                </external-link>
              </div>
              <div>
                <external-link
                  url="https://www.mhlw.go.jp/content/10900000/000641696.pdf"
                >
                  {{
                    $t(
                      '厚生労働省 / 医療機関での医療提供体制について （別紙３）[PDF]'
                    )
                  }}
                </external-link>
              </div>
            </div>
          </div>
        </template>
      </monitoring-confirmed-cases-chart>
    </client-only>
  </v-col>
</template>

<script>
import MonitoringConfirmedCasesChart from '@/components/MonitoringConfirmedCasesChart.vue'
import Data from '@/data/daily_positive_detail.json'
import ExternalLink from '@/components/ExternalLink.vue'
import {
  getNumberToFixedFunction,
  getNumberToLocaleStringFunction,
} from '@/utils/monitoringStatusValueFormatters'

export default {
  components: {
    MonitoringConfirmedCasesChart,
    ExternalLink,
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
    const dataLabels = [this.$t('陽性者数'), this.$t('７日間移動平均')]
    const tableLabels = [this.$t('陽性者数'), this.$t('７日間移動平均')]
    const date = Data.date

    const getFormatter = (columnIndex) => {
      // モニタリング指標(1)新規陽性者数の7日間移動平均は小数点第1位まで表示する。
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

<template>
  <v-col
    id="EffectiveReproductionNumberCard"
    cols="12"
    :md="md"
    class="DataCard"
  >
    <client-only>
      <effective-reproduction-number-chart
        title-id="effective-reproduction-number"
        :info-titles="[$t('EffectiveReproductionNumberCard.title')]"
        chart-id="effective-reproduction-number-chart"
        :chart-data="chartData"
        :get-formatter="getFormatter"
        :date="date"
        :labels="labels"
        :data-labels="dataLabels"
        :table-labels="tableLabels"
      >
        <template #selectCity>
          <v-select
            v-model="select"
            :items="items"
            return-object
            @input="handleChangeCity"
          />
        </template>
        <template #notes>
          <ul>
            <li>
              {{ $t('NIID 国立感染症研究所') }}
              <app-link
                to="https://www.niid.go.jp/niid/ja/diseases/ka/corona-virus/2019-ncov/2502-idsc/iasr-in/10465-496d04.html"
              >
                {{
                  $t(
                    'COVID-19感染報告者数に基づく簡易実効再生産数推定方法(IASR Vol.42 p128-129: 2021年6月号)'
                  )
                }}
              </app-link>
              {{ $t('を用いて計算') }}
            </li>
            <li
              v-for="(note, i) in $t('EffectiveReproductionNumberCard.notes')"
              :key="i"
            >
              {{ note }}
            </li>
          </ul>
        </template>
      </effective-reproduction-number-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'
import { TranslateResult } from 'vue-i18n'

import AppLink from '@/components/_shared/AppLink.vue'
import EffectiveReproductionNumberChart from '@/components/index/CardsMonitoring/EffectiveReproductionNumber/Chart.vue'
import DailyPositiveDetail from '@/data/daily_positive_detail.json'
import Data from '@/data/data.json'
import { getNumberToFixedFunction } from '@/utils/monitoringStatusValueFormatters'

type SelectItem = {
  text: string
  value: string
}

type DataType = {
  date: string
  dataLabels: string[] | TranslateResult[]
  tableLabels: string[] | TranslateResult[]
  getFormatter: Function
  select: SelectItem
  items: SelectItem[]
}

type MethodsType = {
  handleChangeCity: (selected: SelectItem) => void
}

type ComputedType = {
  labels: string[]
  chartData: number[][]
}

type PropsType = {}

const hokenArea: { [char: string]: string[] } = {
  岩手県全域: ['岩手県全域'],
  盛岡市保健所管内: ['盛岡市'],
  県央保健所管内: [
    '八幡平市',
    '滝沢市',
    '雫石町',
    '葛巻町',
    '岩手町',
    '紫波町',
    '矢巾町',
  ],
  中部保健所管内: ['花巻市', '遠野市', '北上市', '西和賀町'],
  奥州保健所管内: ['奥州市', '金ケ崎町'],
  一関保健所管内: ['一関市', '平泉町'],
  大船渡保健所管内: ['大船渡市', '陸前高田市', '住田町'],
  釜石保健所管内: ['釜石市', '大槌町'],
  宮古保健所管内: ['宮古市', '山田町', '岩泉町', '田野畑村'],
  久慈保健所管内: ['久慈市', '普代村', '野田村', '洋野町'],
  二戸保健所管内: ['二戸市', '軽米町', '九戸村', '一戸町'],
}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  DataType,
  MethodsType,
  ComputedType,
  PropsType
> = {
  components: {
    AppLink,
    EffectiveReproductionNumberChart,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const dataLabels = [this.$t('EffectiveReproductionNumberCard.legends[0]')]
    const tableLabels = [this.$t('EffectiveReproductionNumberCard.legends[0]')]
    const date = DailyPositiveDetail.date

    const getFormatter = () => {
      // 実効再生産数(推定値)は小数点第2位まで表示する。
      return getNumberToFixedFunction(2)
    }

    // ここが初期表示される項目
    const select = {
      text: '岩手県全域',
      value: '岩手県全域',
    }
    const items = Object.entries(hokenArea).map((a) => {
      // 岩手県全域の場合は市町村を()に入れない
      const text =
        a[0] === '岩手県全域' ? `${a[0]}` : `${a[0]} (${a[1].join('/')})`
      return {
        text,
        value: a[0],
      }
    })

    return {
      date,
      dataLabels,
      tableLabels,
      getFormatter,
      select,
      items,
    }
  },
  computed: {
    chartData() {
      // 扱う日付の配列
      const labels = this.labels

      // 岩手県全域の陽性者データ
      let patients = Data.patients.data
      // 岩手県全域以外の場合は、選択した保健所管内に属する市町村の陽性者データ
      if (this.select.text !== '岩手県全域') {
        patients = patients.filter((a) => {
          return [this.select.value, ...hokenArea[this.select.value]].includes(
            a.居住地
          )
        })
      }

      // labelの配列項目の日付に対応する、その日の盛岡市の感染者の数
      const patientsCount = labels.map((a) => {
        return patients.filter((b) => b.確定日 === a).length
      })

      // 実効再生産数(推定値)の計算
      // https://www.niid.go.jp/niid/ja/diseases/ka/corona-virus/2019-ncov/2502-idsc/iasr-in/10465-496d04.html
      // 20210711 m1
      // 20210710 m1
      // 20210709 m1
      // 20210708 m1
      // 20210707 m1
      // 20210706 m1 m2
      // 20210705 m1 m2
      // 20210704    m2
      // 20210703    m2
      // 20210702    m2
      // 20210701    m2
      // 20210630    m2
      // 世代時間を5日とする
      const gt = 5
      const effectiveReproductionNumber: number[] = []
      labels.forEach((_currentValue, index, _array) => {
        let rt = 0
        // データの前半は0にする
        if (index >= 11) {
          const i1 = index - 6
          const m1 = patientsCount.slice(i1, index + 1)
          const i2 = index - 6 - gt
          const m2 = patientsCount.slice(i2, index + 1 - gt)
          const m1sum = m1.reduce((a, b) => a + b, 0)
          const m2sum = m2.reduce((a, b) => a + b, 0)
          // 0での割り算の場合は0とする
          if (m2sum !== 0) {
            rt = m1sum / m2sum
          }
        }
        effectiveReproductionNumber.push(rt)
      })

      return [effectiveReproductionNumber]
    },
    labels() {
      return DailyPositiveDetail.data.map((a) => a.diagnosed_date)
    },
  },
  methods: {
    handleChangeCity(selected) {
      this.select = selected
    },
  },
}

export default Vue.extend(options)
</script>

<template>
  <v-col
    id="MonitoringConfirmedCasesNumberPer100kCard"
    cols="12"
    md="12"
    class="DataCard"
  >
    <client-only>
      <monitoring-confirmed-cases-chart-per-100k-chart
        title-id="monitoring-number-of-confirmed-cases-per-100k"
        :info-titles="[$t('MonitoringConfirmedCasesNumberPer100kCard.title')]"
        chart-id="monitoring-number-of-confirmed-cases-per-100k-chart"
        :chart-data="chartData"
        :get-formatter="getFormatter"
        :date="date"
        :labels="labels"
        :data-labels="dataLabels"
        :table-labels="tableLabels"
        :unit="$t('Common.人')"
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
      </monitoring-confirmed-cases-chart-per-100k-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'
import { TranslateResult } from 'vue-i18n'

import MonitoringConfirmedCasesChartPer100kChart from '@/components/index/CardsMonitoring/MonitoringConfirmedCasesNumberPer100k/Chart.vue'
import DailyPositiveDetail from '@/data/daily_positive_detail.json'
import Data from '@/data/data.json'
import {
  getNumberToFixedFunction,
  getNumberToLocaleStringFunction,
} from '@/utils/monitoringStatusValueFormatters'

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
  population: number
}

type PropsType = {}

const populations: { [chr: string]: number } = {
  盛岡市: 289893,
  宮古市: 50401,
  大船渡市: 34739,
  花巻市: 93234,
  北上市: 93089,
  久慈市: 33063,
  遠野市: 25381,
  一関市: 111970,
  陸前高田市: 18271,
  釜石市: 32096,
  二戸市: 25528,
  八幡平市: 24042,
  奥州市: 113027,
  滝沢市: 55600,
  雫石町: 15742,
  葛巻町: 5638,
  岩手町: 12294,
  紫波町: 32166,
  矢巾町: 28076,
  西和賀町: 5137,
  金ケ崎町: 15545,
  平泉町: 7258,
  住田町: 5050,
  大槌町: 11013,
  山田町: 14332,
  岩泉町: 8732,
  田野畑村: 3059,
  普代村: 2489,
  軽米町: 8423,
  野田村: 3938,
  九戸村: 5376,
  洋野町: 15098,
  一戸町: 11506,
}

const hokenArea: { [char: string]: string[] } = {
  岩手県全域: Object.keys(populations),
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
    MonitoringConfirmedCasesChartPer100kChart,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const dataLabels = [
      this.$t('MonitoringConfirmedCasesNumberPer100kCard.legends[0]'),
      this.$t('MonitoringConfirmedCasesNumberPer100kCard.legends[1]'),
    ]
    const tableLabels = [
      this.$t('MonitoringConfirmedCasesNumberPer100kCard.legends[0]'),
      this.$t('MonitoringConfirmedCasesNumberPer100kCard.legends[1]'),
    ]
    const date = DailyPositiveDetail.date

    const getFormatter = (columnIndex: number) => {
      // 新規陽性者数の7日間移動平均は小数点第1位まで表示する。
      if (columnIndex === 1) {
        return getNumberToFixedFunction(1)
      }
      return getNumberToLocaleStringFunction()
    }

    // ここが初期表示される項目
    const select = {
      text: '中部保健所管内 (花巻市/遠野市/北上市/西和賀町)',
      value: '中部保健所管内',
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

      // 1週間あたり10万人あたりの陽性者数
      const sevenDayMoveAveragesPer10k: number[] = []
      labels.forEach((_currentValue, index, _array) => {
        const i = index - 6 < 0 ? 0 : index - 6
        const p = patientsCount.slice(i, index + 1)
        sevenDayMoveAveragesPer10k.push(
          (p.reduce((a, b) => a + b, 0) * 100000) / this.population
        )
      })

      return [patientsCount, sevenDayMoveAveragesPer10k]
    },
    labels() {
      return DailyPositiveDetail.data.map((a) => a.diagnosed_date)
    },
    population() {
      return Object.keys(populations)
        .filter((a) => hokenArea[this.select.value].includes(a))
        .map((a) => populations[a])
        .reduce((accumulator, currentValue, _index, _array) => {
          return accumulator + currentValue
        }, 0)
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

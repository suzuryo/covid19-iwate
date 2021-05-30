<template>
  <v-col
    id="ConfirmedCasesByMunicipalitiesCard"
    cols="12"
    :md="md"
    class="DataCard"
  >
    <client-only>
      <confirmed-cases-by-municipalities-table
        :title="$t('ConfirmedCasesByMunicipalitiesCard.title')"
        :title-id="'number-of-confirmed-cases-by-municipalities'"
        :chart-data="municipalitiesTable"
        :date="date"
        :info="info"
      >
        <template #notes>
          <ul>
            <li
              v-for="note in $t('ConfirmedCasesByMunicipalitiesCard.notes')"
              :key="note"
            >
              {{ note }}
            </li>
          </ul>
        </template>
      </confirmed-cases-by-municipalities-table>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import dayjs from 'dayjs'

import ConfirmedCasesByMunicipalitiesTable from '@/components/index/CardsMonitoring/ConfirmedCasesByMunicipalities/Table.vue'
import Data from '@/data/data.json'
import PatientMunicipalities from '@/data/patient_municipalities.json'

const population = {
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

export default {
  components: {
    ConfirmedCasesByMunicipalitiesTable,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    // 市町村ごとの陽性患者数
    const municipalitiesTable = {
      headers: [],
      datasets: [],
    }

    // ヘッダーを設定
    municipalitiesTable.headers = [
      {
        text: this.$t('ConfirmedCasesByMunicipalitiesCard.legends[0]'),
        value: 'label',
      },
      {
        text: this.$t('ConfirmedCasesByMunicipalitiesCard.legends[1]'),
        value: 'count',
        align: 'end',
      },
      {
        text: this.$t('ConfirmedCasesByMunicipalitiesCard.legends[2]'),
        value: 'count_per_population',
        align: 'end',
      },
      {
        text: this.$t('ConfirmedCasesByMunicipalitiesCard.legends[3]'),
        value: 'last7days',
        align: 'end',
      },
      {
        text: this.$t('ConfirmedCasesByMunicipalitiesCard.legends[4]'),
        value: 'last7_per_100k',
        align: 'end',
      },
    ]

    const getCountPerPopulation = (d) => {
      return d === null ? '' : `${d}%`
    }

    const getLast7days = (d) => {
      const last7 = Data.patients.data
        .filter((a) => a.居住地 === d)
        .filter((a) =>
          dayjs(a.確定日).isAfter(
            dayjs(
              Data.patients_summary.data[Data.patients_summary.data.length - 1]
                .日付
            ).add(-8, 'days') // 確定日の翌日に発表があるので -7 じゃなくて -8
          )
        )
      return d === '県外' ? '' : last7.length
    }

    const getLast7DaysPer100k = (d) => {
      return d === '県外'
        ? ''
        : ((getLast7days(d) * 100000) / population[d]).toFixed(1)
    }

    // データを追加
    municipalitiesTable.datasets = PatientMunicipalities.datasets.data
      .filter((d) => d.label !== '小計')
      .map((d) => {
        return {
          code: d.code,
          ruby: this.$t(d.ruby),
          label: this.$t(d.label),
          count: d.count,
          count_per_population: getCountPerPopulation(d.count_per_population),
          last7days: getLast7days(d.label),
          last7_per_100k: getLast7DaysPer100k(d.label),
        }
      })

    const date = dayjs(PatientMunicipalities.date).format('YYYY/MM/DD HH:mm')

    const info = {
      sText: this.$t('Common.{date}の累計', {
        date: this.$d(
          new Date(PatientMunicipalities.datasets.date),
          'dateWithoutYear'
        ),
      }),
    }

    return {
      date,
      municipalitiesTable,
      info,
    }
  },
}
</script>

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

import Data from '@/data/patient_municipalities.json'
import ConfirmedCasesByMunicipalitiesTable from '~/components/ConfirmedCasesByMunicipalitiesTable.vue'

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
        value: 'ruby',
      },
      {
        text: this.$t('ConfirmedCasesByMunicipalitiesCard.legends[2]'),
        value: 'count',
        align: 'end',
      },
      {
        text: this.$t('ConfirmedCasesByMunicipalitiesCard.legends[3]'),
        value: 'count_per_population',
        align: 'end',
      },
    ]

    // データをソート
    Data.datasets.data.sort((a, b) => {
      // 全体をcodeでソート
      if (a.code === b.code) {
        return 0
      } else if (a.code > b.code) {
        return 1
      } else {
        return -1
      }
    })

    const getCountPerPopulation = (d) => {
      if (d === null) {
        return ''
      } else {
        return `${d}%`
      }
    }

    // データを追加
    municipalitiesTable.datasets = Data.datasets.data
      .filter((d) => d.label !== '小計')
      .map((d) => {
        return {
          area: this.$t(d.area),
          ruby: this.$t(d.ruby),
          label: this.$t(d.label),
          count: d.count,
          count_per_population: getCountPerPopulation(d.count_per_population),
        }
      })

    const date = dayjs(Data.date).format('YYYY/MM/DD HH:mm')

    const info = {
      sText: this.$t('Common.{date}の累計', {
        date: this.$d(new Date(Data.datasets.date), 'dateWithoutYear'),
      }),
    }

    return {
      Data,
      date,
      municipalitiesTable,
      info,
    }
  },
}
</script>

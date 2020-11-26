<template>
  <v-col cols="12" md="6" class="DataCard">
    <client-only>
      <confirmed-cases-by-municipalities-table
        :title="$t('陽性患者数（市町村別）')"
        :title-id="'number-of-confirmed-cases-by-municipalities'"
        :chart-data="municipalitiesTable"
        :date="date"
        :info="info"
      >
        <template v-slot:additionalDescription>
          <span>{{ $t('（注）') }}</span>
          <ul>
            <li>
              {{ $t('前日までに報告された陽性者数の累計値') }}
            </li>
            <li>
              {{
                $t(
                  '陽性者数/人口 は市町村の人口(令和2年10月1日現在)に対する陽性者数の割合'
                )
              }}
            </li>
          </ul>
        </template>
      </confirmed-cases-by-municipalities-table>
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
  data() {
    // 市町村ごとの陽性患者数
    const municipalitiesTable = {
      headers: [],
      datasets: [],
    }

    // ヘッダーを設定
    municipalitiesTable.headers = [
      { text: this.$t('市町村'), value: 'label' },
      { text: this.$t('ふりがな'), value: 'ruby' },
      { text: this.$t('陽性者数'), value: 'count', align: 'end' },
      {
        text: this.$t('陽性者数/人口'),
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
      sText: this.$t('{date}の累計', {
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

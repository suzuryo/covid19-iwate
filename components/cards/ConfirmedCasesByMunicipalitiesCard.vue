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
            <!--
            <li>
              {{ $t('チャーター機帰国者、クルーズ船乗客等は含まれていない') }}
            </li>
            -->
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
    if (this.$i18n.locale === 'ja') {
      municipalitiesTable.headers = [
        { text: this.$t('市町村'), value: 'label' },
        { text: this.$t('ふりがな'), value: 'ruby' },
        { text: this.$t('陽性者数'), value: 'count', align: 'end' },
      ]
    } else {
      municipalitiesTable.headers = [
        { text: this.$t('市町村'), value: 'label' },
        { text: this.$t('陽性者数'), value: 'count', align: 'end' },
      ]
    }

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

    // データを追加
    municipalitiesTable.datasets = Data.datasets.data
      .filter((d) => d.label !== '小計')
      .map((d) => {
        if (this.$i18n.locale === 'ja') {
          return {
            area: this.$t(d.area),
            ruby: this.$t(d.ruby),
            label: this.$t(d.label),
            count: d.count,
          }
        } else {
          return {
            area: this.$t(d.area),
            label: this.$t(d.label),
            count: d.count,
          }
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

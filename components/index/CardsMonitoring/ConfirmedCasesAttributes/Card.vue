<template>
  <v-col id="ConfirmedCasesAttributesCard" cols="12" :md="md" class="DataCard">
    <client-only>
      <data-table
        :title="$t('ConfirmedCasesAttributesCard.title')"
        :title-id="'attributes-of-confirmed-cases'"
        :chart-data="patientsTable"
        :chart-option="{}"
        :date="Data.patients.date"
        :info="sumInfoOfPatients"
        :custom-sort="customSort"
      >
        <template #notes>
          <ul>
            <li
              v-for="note in $t('ConfirmedCasesAttributesCard.notes')"
              :key="note"
            >
              {{ note }}
            </li>
          </ul>
        </template>
      </data-table>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import DataTable from '@/components/index/CardsMonitoring/ConfirmedCasesAttributes/DataTable.vue'
import Data from '@/data/data.json'
import { getDayjsObject } from '@/utils/formatDate'
import formatTable from '@/utils/formatTable'

export default {
  components: {
    DataTable,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    // 感染者数
    const patientsTable = formatTable(Data.patients.data)
    // 日付
    const lastDay = Data.patients.data[Data.patients.data.length - 1].確定日
    const date = this.$d(getDayjsObject(lastDay).toDate(), 'dateWithoutYear')

    const sumInfoOfPatients = {
      lText: `${Data.patients.data[Data.patients.data.length - 1].id}`,
      sText: this.$t('Common.{date}の累計', { date }),
      unit: this.$t('Common.人'),
    }

    // 陽性者の属性 ヘッダー翻訳
    for (const header of patientsTable.headers) {
      header.text = this.$t(header.value)
    }

    // 陽性者の属性 中身の翻訳
    for (const row of patientsTable.datasets) {
      // 相対発症日・無症状・不明
      if (row['発症日'] === '無症状') {
        row['発症日'] = this.$t('ConfirmedCasesAttributesCard.table.無症状')
      } else if (row['発症日'] === '不明') {
        row['発症日'] = this.$t('ConfirmedCasesAttributesCard.table.不明')
      } else {
        const d = row['発症日'].replace('日前', '')
        row['発症日'] = this.$tc(
          'ConfirmedCasesAttributesCard.table.daysbefore',
          d,
          { d }
        )
      }

      // 居住地
      row['居住地'] = this.getTranslatedWording(row['居住地'])

      // 年代
      if (row['年代'].substr(-1, 1) === '代') {
        const age = row['年代'].substring(0, 2)
        row['年代'] = this.$t('ConfirmedCasesAttributesCard.table.{age}代', {
          age,
        })
      } else {
        row['年代'] = this.$t(
          `ConfirmedCasesAttributesCard.table.${row['年代']}`
        )
      }

      // 接触歴
      if (row['接触歴'] === '判明') {
        row['接触歴'] = ''
      } else {
        row['接触歴'] = this.$t('ConfirmedCasesAttributesCard.table.無')
      }
    }

    return {
      Data,
      patientsTable,
      sumInfoOfPatients,
    }
  },
  methods: {
    getTranslatedWording(value) {
      if (
        value === '-' ||
        value === '‐' ||
        value === '―' ||
        value === '－' ||
        value === null
      ) {
        // 翻訳しようとしている文字列が以下のいずれかだった場合、翻訳しない
        // - 全角のハイフン
        // - 半角のハイフン
        // - 全角のダッシュ
        // - 全角ハイフンマイナス
        // - null
        return value
      }

      return this.$t(value)
    },
    customSort(items, index, isDesc) {
      const lt10 = this.$t(
        'ConfirmedCasesAttributesCard.table.10歳未満'
      ).toString()
      const lt90 = this.$t(
        'ConfirmedCasesAttributesCard.table.90歳以上'
      ).toString()

      items.sort((a, b) => {
        let comparison = 0
        switch (index[0]) {
          case 'ConfirmedCasesAttributesCard.table.通番':
            comparison = parseInt(a.id) < parseInt(b.id) ? -1 : 1
            break
          case 'ConfirmedCasesAttributesCard.table.確定日':
            comparison = new Date(a[index[0]]) < new Date(b[index[0]]) ? -1 : 1
            break
          case 'ConfirmedCasesAttributesCard.table.発症日':
            comparison = String(a.発症日) < String(b.発症日) ? -1 : 1
            break
          case 'ConfirmedCasesAttributesCard.table.居住地':
            comparison = String(a.居住地) < String(b.居住地) ? -1 : 1
            break
          case 'ConfirmedCasesAttributesCard.table.年代':
            if (a.年代 === lt10 || b.年代 === lt10) {
              comparison = a.年代 === lt10 ? -1 : 1
            } else if (a.年代 === lt90 || b.年代 === lt90) {
              comparison = a.年代 === lt90 ? 1 : -1
            } else {
              comparison = String(a.年代) < String(b.年代) ? -1 : 1
            }
            break
          case 'ConfirmedCasesAttributesCard.table.接触歴':
            comparison = String(a.接触歴) < String(b.接触歴) ? -1 : 1
            break
          case 'ConfirmedCasesAttributesCard.table.📺':
            comparison = String(a.yt) < String(b.yt) ? -1 : 1
            break
          default:
            comparison = parseInt(a.id) > parseInt(b.id) ? -1 : 1
            break
        }
        return isDesc[0] ? comparison * -1 : comparison
      })
      return items
    },
  },
}
</script>

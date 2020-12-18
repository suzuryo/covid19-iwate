<template>
  <v-col cols="12" md="6" class="DataCard">
    <client-only>
      <data-view
        :title="$t('Details.a[0]')"
        :title-id="'details-of-confirmed-cases'"
        :date="updatedAt"
      >
        <template #additionalDescription />
        <confirmed-cases-details-table
          :aria-label="$t('Details.a[0]')"
          v-bind="confirmedCases"
        />
      </data-view>
    </client-only>
  </v-col>
</template>

<script>
import dayjs from 'dayjs'
import Data from '@/data/data.json'
import formatConfirmedCases from '@/utils/formatConfirmedCases'
import DataView from '@/components/DataView.vue'
import ConfirmedCasesDetailsTable from '@/components/ConfirmedCasesDetailsTable.vue'

export default {
  components: {
    DataView,
    ConfirmedCasesDetailsTable,
  },
  data() {
    // 検査陽性者の状況
    const confirmedCases = formatConfirmedCases(Data.main_summary)

    const updatedAt = dayjs(Data.main_summary.children[0].date).format(
      'YYYY/MM/DD HH:mm'
    )

    return {
      Data,
      confirmedCases,
      updatedAt,
    }
  },
}
</script>

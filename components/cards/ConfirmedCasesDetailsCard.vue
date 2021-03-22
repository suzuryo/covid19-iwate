<template>
  <v-col id="ConfirmedCasesDetailsCard" cols="12" :md="md" class="DataCard">
    <client-only>
      <data-view
        :title="$t('ConfirmedCasesDetailsCard.title')"
        :title-id="'details-of-confirmed-cases'"
        :date="updatedAt"
      >
        <confirmed-cases-details-table
          :aria-label="$t('ConfirmedCasesDetailsCard.title')"
          v-bind="confirmedCases"
        />
        <template #dataSetPanel>
          <data-view-data-set-panel
            :title="$t('ConfirmedCasesDetailsCard.title')"
            :card-path="`/cards/details-of-confirmed-cases`"
          />
        </template>
      </data-view>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import dayjs from 'dayjs'

import ConfirmedCasesDetailsTable from '@/components/ConfirmedCasesDetailsTable.vue'
import DataView from '@/components/DataView.vue'
import DataViewDataSetPanel from '@/components/DataViewDataSetPanel.vue'
import Data from '@/data/data.json'
import formatConfirmedCases from '@/utils/formatConfirmedCases'

export default {
  components: {
    DataView,
    DataViewDataSetPanel,
    ConfirmedCasesDetailsTable,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
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

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
          v-bind="MainSummary"
        />
        <template #notes>
          <notes-expansion-panel
            class="DataView-ExpansionPanel"
            :expansion-panel-text="$t('Common.注')"
          >
            <template #notes>
              <ul>
                <li
                  v-for="note in $t('ConfirmedCasesDetailsCard.notes')"
                  :key="note"
                >
                  {{ note }}
                </li>
              </ul>
            </template>
          </notes-expansion-panel>
        </template>
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

import DataView from '@/components/index/_shared/DataView.vue'
import NotesExpansionPanel from '@/components/index/_shared/DataView/NotesExpansionPanel.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'
import ConfirmedCasesDetailsTable from '@/components/index/CardsMonitoring/ConfirmedCasesDetails/Table.vue'
import MainSummary from '@/data/main_summary.json'

export default {
  components: {
    DataView,
    NotesExpansionPanel,
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

    const updatedAt = dayjs(MainSummary.date).format('YYYY/MM/DD HH:mm')

    return {
      MainSummary,
      updatedAt,
    }
  },
}
</script>

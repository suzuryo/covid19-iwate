<template>
  <v-col id="TestedNumberCard" cols="12" :md="md" class="DataCard">
    <client-only>
      <time-stacked-bar-chart
        :title="$t('TestedNumberCard.title')"
        :title-id="'number-of-tested'"
        :chart-id="'time-stacked-bar-chart-inspections'"
        :chart-data="inspectionsGraph"
        :date="PositiveRate.date"
        :items="inspectionsItems"
        :labels="inspectionsLabels"
        :unit="$t('件.tested')"
        :data-labels="inspectionsDataLabels"
        :table-labels="inspectionsTableLabels"
      >
        <template #notes>
          <ul>
            <li v-for="(note, i) in $t('TestedNumberCard.notes')" :key="i">
              {{ note }}
            </li>
          </ul>
        </template>
      </time-stacked-bar-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import dayjs from 'dayjs'
import duration from 'dayjs/plugin/duration'

import TimeStackedBarChart from '@/components/TimeStackedBarChart.vue'
import PositiveRate from '@/data/positive_rate.json'
import { getDayjsObject } from '@/utils/formatDate'
dayjs.extend(duration)

export default {
  components: {
    TimeStackedBarChart,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    // 検査実施日別状況
    const pcr = PositiveRate.data.map((d) => {
      return (d.pcr_positive_count ?? 0) + (d.pcr_negative_count ?? 0)
    })
    const antigen = PositiveRate.data.map((d) => {
      return (d.antigen_positive_count ?? 0) + (d.antigen_negative_count ?? 0)
    })
    const inspectionsGraph = [pcr, antigen]
    const inspectionsItems = [
      this.$t('TestedNumberCard.legends[0]'),
      this.$t('TestedNumberCard.legends[1]'),
    ]
    const inspectionsLabels = PositiveRate.data.map((d) => {
      return getDayjsObject(d.diagnosed_date).format('YYYY-MM-DD')
    })
    const inspectionsDataLabels = [
      this.$t('TestedNumberCard.legends[0]'),
      this.$t('TestedNumberCard.legends[1]'),
    ]
    const inspectionsTableLabels = [
      this.$t('TestedNumberCard.legends[0]'),
      this.$t('TestedNumberCard.legends[1]'),
    ]

    return {
      PositiveRate,
      inspectionsGraph,
      inspectionsItems,
      inspectionsLabels,
      inspectionsDataLabels,
      inspectionsTableLabels,
    }
  },
}
</script>

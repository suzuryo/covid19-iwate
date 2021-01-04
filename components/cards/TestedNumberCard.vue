<template>
  <v-col id="TestedNumberCard" cols="12" md="6" class="DataCard">
    <client-only>
      <time-stacked-bar-chart
        :title="$t('検査実施件数')"
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
        <!-- 件.tested = 検査数 -->
        <template #notes>
          <ul>
            <li>
              {{
                $t(
                  '速報値として公開するものであり、後日確定データとして修正される場合がある'
                )
              }}
            </li>
          </ul>
        </template>
      </time-stacked-bar-chart>
    </client-only>
  </v-col>
</template>

<script>
import dayjs from 'dayjs'
import duration from 'dayjs/plugin/duration'
import PositiveRate from '@/data/positive_rate.json'
import { getDayjsObject } from '@/utils/formatDate'
import TimeStackedBarChart from '@/components/TimeStackedBarChart.vue'
dayjs.extend(duration)

export default {
  components: {
    TimeStackedBarChart,
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
      this.$t('PCR検査実施件数'),
      this.$t('抗原検査件数'),
    ]
    const inspectionsLabels = PositiveRate.data.map((d) => {
      return getDayjsObject(d.diagnosed_date).format('YYYY-MM-DD')
    })
    const inspectionsDataLabels = [
      this.$t('PCR検査実施件数'),
      this.$t('抗原検査件数'),
    ]
    const inspectionsTableLabels = [
      this.$t('PCR検査実施件数'),
      this.$t('抗原検査件数'),
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

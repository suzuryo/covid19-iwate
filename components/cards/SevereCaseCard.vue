<template>
  <v-col id="SevereCaseCard" cols="12" md="6" class="DataCard">
    <client-only>
      <severe-case-bar-chart
        title-id="positive-status-severe-case"
        :info-titles="[$t('重症患者数')]"
        chart-id="time-bar-chart-positive-status-severe-case"
        :chart-data="graphData"
        :date="Data.date"
        :unit="$t('Common.人')"
      >
        <template #notes>
          <ul>
            <li>
              {{
                $t(
                  '入院患者数のうち、人工呼吸器管理（ECMOを含む）が必要な患者数を計上'
                )
              }}
            </li>
          </ul>
        </template>
      </severe-case-bar-chart>
    </client-only>
  </v-col>
</template>

<script>
import SevereCaseBarChart from '@/components/SevereCaseBarChart.vue'
import Data from '@/data/positive_status.json'
import { convertDateToISO8601Format } from '@/utils/formatDate.ts'

export default {
  components: {
    SevereCaseBarChart,
  },
  data() {
    const graphData = Data.data
      .filter((d) => new Date(d.date) > new Date('2020-04-26'))
      .filter((d) => !isNaN(d.severe_case))
      .map((d) => ({
        label: convertDateToISO8601Format(d.date),
        transition: d.severe_case,
      }))
    return {
      Data,
      graphData,
    }
  },
}
</script>

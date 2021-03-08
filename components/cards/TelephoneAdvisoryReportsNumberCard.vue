<template>
  <v-col
    id="TelephoneAdvisoryReportsNumberCard"
    cols="12"
    :md="md"
    class="DataCard"
  >
    <client-only>
      <time-bar-chart
        :title="$t('TelephoneAdvisoryReportsNumberCard.title')"
        :title-id="'number-of-reports-to-covid19-telephone-advisory-center'"
        :chart-id="'time-bar-chart-contacts'"
        :chart-data="contactsGraph"
        :date="Data.contacts.date"
        :unit="$t('件.reports')"
      >
        <!-- 件.reports = 窓口相談件数 -->
        <template #notes>
          <ul>
            <li
              v-for="(note, i) in $t(
                'TelephoneAdvisoryReportsNumberCard.notes'
              )"
              :key="i"
            >
              {{ note }}
            </li>
          </ul>
        </template>
      </time-bar-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import TimeBarChart from '@/components/TimeBarChart.vue'
import Data from '@/data/data.json'
import formatGraph from '@/utils/formatGraph'

export default {
  components: {
    TimeBarChart,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    // 相談件数
    const contactsGraph = formatGraph(Data.contacts.data)

    return {
      Data,
      contactsGraph,
    }
  },
}
</script>

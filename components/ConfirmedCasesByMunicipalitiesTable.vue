<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <v-data-table
      :ref="'displayedTable'"
      :headers="chartData.headers"
      :items="chartData.datasets"
      :items-per-page="-1"
      :hide-default-footer="true"
      :height="580"
      :fixed-header="true"
      :mobile-breakpoint="0"
      :custom-sort="customSort"
      class="cardTable"
    />
    <template #notes>
      <notes-expansion-panel
        class="DataView-ExpansionPanel"
        :expansion-panel-text="$t('Common.注')"
      >
        <template #notes>
          <slot name="notes" />
        </template>
      </notes-expansion-panel>
    </template>
    <template #dataSetPanel>
      <data-view-data-set-panel
        :title="title"
        :l-text="info.lText"
        :s-text="info.sText"
        :unit="info.unit"
        :card-path="`/cards/${titleId}`"
      />
    </template>
  </data-view>
</template>

<script lang="ts">
import Vue from 'vue'

import DataView from '@/components/DataView.vue'
import DataViewDataSetPanel from '@/components/DataViewDataSetPanel.vue'
import NotesExpansionPanel from '@/components/NotesExpansionPanel.vue'

export default Vue.extend({
  components: { DataView, DataViewDataSetPanel, NotesExpansionPanel },
  props: {
    title: {
      type: String,
      default: '',
    },
    titleId: {
      type: String,
      default: '',
    },
    chartData: {
      type: Object,
      default: () => {},
    },
    date: {
      type: String,
      default: '',
    },
    info: {
      type: Object,
      default: () => {},
    },
  },
  mounted() {
    const vTables = this.$refs.displayedTable as Vue
    const vTableElement = vTables.$el
    const tables = vTableElement.querySelectorAll('table')
    // NodeListをIE11でforEachするためのワークアラウンド
    const nodes = Array.prototype.slice.call(tables, 0)
    nodes.forEach((table: HTMLElement) => {
      table.setAttribute('tabindex', '0')
    })
  },
  methods: {
    customSort(items: Object[], index: string[], isDesc: boolean[]) {
      items.sort((a: any, b: any) => {
        let comparison: number

        // 「県外」は常に一番下にする
        if (a.code === '999999') {
          return 1
        }
        if (b.code === '999999') {
          return -1
        }

        switch (index[0]) {
          case 'label':
            // 「市町村(label)」(漢字)でソートすると、実は「ふりがな(ruby)」(ひらがな)でソートされる
            comparison = a.ruby < b.ruby ? -1 : 1
            break
          case 'count':
            // 「陽性者数」はIntとしてソートする
            comparison = parseInt(a.count) < parseInt(b.count) ? -1 : 1
            break
          case 'count_per_population':
            // 「対人口」は%を取り除いてFloatとしてソートする
            comparison =
              parseFloat(a.count_per_population) <
              parseFloat(b.count_per_population)
                ? -1
                : 1
            break
          case 'last7days':
            // 「直近1週間」はIntとしてソートする
            comparison = parseInt(a.last7days) < parseInt(b.last7days) ? -1 : 1
            break
          case 'last7_per_100k':
            // 「直近1週間対人口10万人」はFloatとしてソートする
            comparison =
              parseFloat(a.last7_per_100k) < parseFloat(b.last7_per_100k)
                ? -1
                : 1
            break
          default:
            comparison = parseInt(a.code) - parseInt(b.code)
            break
        }
        return isDesc[0] ? comparison * -1 : comparison
      })
      return items
    },
  },
})
</script>

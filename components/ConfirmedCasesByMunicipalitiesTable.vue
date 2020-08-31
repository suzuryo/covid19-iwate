<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <v-data-table
      :ref="'displayedTable'"
      :headers="chartData.headers"
      :items="chartData.datasets"
      :items-per-page="-1"
      :hide-default-footer="true"
      :height="480"
      :fixed-header="true"
      :mobile-breakpoint="0"
      :custom-sort="customSort"
      class="cardTable"
    />
    <template v-slot:additionalDescription>
      <slot name="additionalDescription" />
    </template>
    <template v-slot:infoPanel>
      <data-view-basic-info-panel
        :l-text="info.lText"
        :s-text="info.sText"
        :unit="info.unit"
      />
    </template>
  </data-view>
</template>

<script lang="ts">
import Vue from 'vue'
import DataView from '@/components/DataView.vue'
import DataViewBasicInfoPanel from '@/components/DataViewBasicInfoPanel.vue'

export default Vue.extend({
  components: { DataView, DataViewBasicInfoPanel },
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
        if (index[0] === 'label') {
          // 「市町村(label)」(漢字)でソートすると、実は「ふりがな(ruby)」(ひらがな)でソートされる
          comparison = a.ruby < b.ruby ? -1 : 1
        } else {
          // 市町村(label)以外は、それ自身でソート
          comparison = a[index[0]] < b[index[0]] ? -1 : 1
        }
        return isDesc[0] ? comparison * -1 : comparison
      })
      return items
    },
  },
})
</script>

<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <div id="weekly_map_canvas" ref="weekly_map_canvas">
      <svg id="weekly_map" />
    </div>
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
        :l-text-before="dataSetPanel.lTextBefore"
        :l-text="dataSetPanel.lText"
        :s-text="dataSetPanel.sText"
        unit="人"
        :card-path="`/cards/${titleId}`"
      />
    </template>
  </data-view>
</template>

<script lang="ts">
import * as d3 from 'd3'
import * as topojson from 'topojson-client'
import Vue from 'vue'

import DataView from '@/components/DataView.vue'
import DataViewDataSetPanel from '@/components/DataViewDataSetPanel.vue'
import NotesExpansionPanel from '@/components/NotesExpansionPanel.vue'
import { MapDataItem } from '@/types/weekly-map'

export default Vue.extend({
  components: { DataView, DataViewDataSetPanel, NotesExpansionPanel },
  props: {
    title: {
      required: true,
      type: String,
      default: '',
    },
    titleId: {
      required: true,
      type: String,
      default: '',
    },
    mapData: {
      required: true,
      type: Array,
    },
    date: {
      required: true,
      type: String,
      default: '',
    },
    info: {
      required: true,
      type: Object,
    },
  },
  data() {
    const dataSetPanel = {
      lTextBefore: this.info.lTextBefore,
      lText: this.info.lText,
      sText: this.info.sText,
    }
    return {
      dataSetPanel,
    }
  },
  mounted() {
    this.dataSetPanel.lText = `${this.last7DaySum()}`
    this.renderMap()
  },
  methods: {
    last7DaySum() {
      return this.mapData
        .map((a: any) => a.last7days)
        .reduce((a: number, c: number) => a + c)
    },
    last7days(city: string) {
      return (this.mapData.find((a: any) => a.label === city) as MapDataItem)
        .last7days
    },
    lastArea(city: string) {
      return (this.mapData.find((a: any) => a.label === city) as MapDataItem)
        .area
    },
    renderMap() {
      d3.json('/03_city.l.topo.json').then((iwate: any) => {
        const svg = d3.select('#weekly_map_canvas svg')
        const width = (this.$refs.weekly_map_canvas as Element).clientWidth
        const topology: any = topojson.feature(iwate, iwate.objects.city)
        const data = topology.features
        // topojsonをgeojsonに変換して岩手県が中心に表示されるように整える
        const projection = d3.geoMercator().translate([width / 2, width / 2])
        const path = d3.geoPath().projection(projection)
        const bounds = d3.geoBounds(topology)
        const center = d3.geoCentroid(topology)
        const distance = d3.geoDistance(bounds[0], bounds[1])
        const scale = (width / distance) * 0.9
        projection.scale(scale).center(center)

        // 市町村以外の部分をクリックしたら県全域
        d3.select('#weekly_map_canvas').on('click', (event) => {
          this.dataSetPanel.lTextBefore = `岩手県全域`
          this.dataSetPanel.lText = `${this.last7DaySum()}`
          this.dataSetPanel.sText = '居住が県外で県内滞在も含む'
          event.stopPropagation()
        })

        // SVGの生成
        svg
          .attr('preserveAspectRatio', 'xMinYMin meet') // レスポンシブ用
          .attr('viewBox', `0 0 ${width} ${width}`) // レスポンシブ用
          .selectAll('g')
          .data(data)
          .enter()
          .append('g')
          .attr('stroke', '#aaa')
          .attr('stroke-width', '1px')
          .attr('fill', (d: any) => {
            // 直近1週間の陽性数に応じて色を変える
            const last7days = this.last7days(d.properties.N03_004)
            const color = d3
              .scaleSequential(d3.interpolateReds)
              .domain([0, this.last7DaySum() * 0.7]) // 最大値の最適値がよくわからないので、とりあえず0.7
            return color(last7days)
          })
          .attr('data-count', (d: any) => {
            // 直近1週間の陽性数
            return this.last7days(d.properties.N03_004)
          })
          .attr('data-name', (d: any) => {
            // 市町村名
            return `${d.properties.N03_004}`
          })
          .attr('data-code', (d: any) => {
            // 市町村コード
            return `${d.properties.N03_007}`
          })
          .attr('data-area', (d: any) => {
            // 管轄保健所
            return `${this.lastArea(d.properties.N03_004)}`
          })
          .on('click', (event, _d) => {
            // 市町村がクリックされたらその地域の情報を表示
            // DataViewDataSetPanelに渡す
            const t = d3.select(event.currentTarget)
            const name = t.attr('data-name')
            const count = t.attr('data-count')
            const area = t.attr('data-area')
            this.dataSetPanel.lTextBefore = name
            this.dataSetPanel.lText = count
            this.dataSetPanel.sText = `${area}を含む`
            event.stopPropagation()
          })
          .append('path')
          .attr('d', path as any)
          .on('mouseenter', function () {
            d3.select(this).attr('opacity', 0.7)
          })
          .on('mouseout', function () {
            d3.select(this).attr('opacity', 1)
          })
          .append('svg:title')
          .text((d: any) => {
            const last7days = this.last7days(d.properties.N03_004)
            return `${d.properties.N03_004} (管轄保健所管内含む) ${last7days} 人`
          })
      })
    },
  },
})
</script>

<style lang="scss">
/* svgのレスポンシブ対応 */
#weekly_map_canvas {
  display: inline-block;
  position: relative;
  width: 100%;
  padding-bottom: 100%;
  vertical-align: top;
  overflow: hidden;
}
#weekly_map {
  display: inline-block;
  position: absolute;
  top: 0;
  left: 0;
}
</style>

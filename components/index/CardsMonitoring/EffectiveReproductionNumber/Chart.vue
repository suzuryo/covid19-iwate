<template>
  <data-view
    :title="title"
    :title-id="titleId"
    :date="date"
    :head-title="title + infoTitles.join(',')"
  >
    <v-col cols="12">
      <slot name="selectCity" />
    </v-col>
    <h4 :id="`${titleId}-graph`" class="visually-hidden">
      {{ $t(`{title}のグラフ`, { title }) }}
    </h4>
    <scrollable-chart v-show="canvas" :display-data="displayData">
      <template #chart="{ chartWidth }">
        <line-chart
          :ref="'lineChart'"
          :chart-id="chartId"
          :chart-data="displayData"
          :options="displayOption"
          :height="240"
          :width="chartWidth"
        />
      </template>
      <template #sticky-chart>
        <line-chart
          class="sticky-legend"
          :chart-id="`${chartId}-header-right`"
          :chart-data="displayDataHeader"
          :options="displayOptionHeader"
          :plugins="yAxesBgPlugin"
          :height="240"
        />
      </template>
    </scrollable-chart>
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
    <template #additionalDescription>
      <slot name="additionalDescription" />
    </template>
    <template #dataTable>
      <client-only>
        <data-view-table :headers="tableHeaders" :items="tableData" />
      </client-only>
    </template>
    <template #dataSetPanel>
      <data-view-data-set-panel
        :title="infoTitles[0]"
        :l-text="displayInfo[0].lText"
        :s-text="displayInfo[0].sText"
        :unit="displayInfo[0].unit"
        :card-path="`/cards/${titleId}`"
      />
    </template>
  </data-view>
</template>

<script lang="ts">
import { Chart } from 'chart.js'
import ChartJsAnnotation from 'chartjs-plugin-annotation'
import dayjs from 'dayjs'
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'
import { TranslateResult } from 'vue-i18n'

import DataView from '@/components/index/_shared/DataView.vue'
import NotesExpansionPanel from '@/components/index/_shared/DataView/NotesExpansionPanel.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'
import DataViewTable, {
  TableHeader,
  TableItem,
} from '@/components/index/_shared/DataViewTable.vue'
import ScrollableChart from '@/components/index/_shared/ScrollableChart.vue'
import { DisplayData, yAxesBgPlugin } from '@/plugins/vue-chart'
import { getGraphSeriesColor, SurfaceStyle } from '@/utils/colors'
import { calcDayBeforeRatio } from '@/utils/formatDayBeforeRatio'
import { getNumberToLocaleStringFunction } from '@/utils/monitoringStatusValueFormatters'

type Data = {
  canvas: boolean
  colors: SurfaceStyle[]
}
type Methods = {}

type ChartJsAnnotationOptions = Chart.ChartOptions & {
  annotation: ChartJsAnnotation.AnnotationConfig
}

type Computed = {
  displayInfo: [
    {
      lText: string
      sText: string
      unit: string
    }
  ]
  displayData: DisplayData
  displayOption: ChartJsAnnotationOptions
  displayDataHeader: DisplayData
  displayOptionHeader: Chart.ChartOptions
  scaledTicksYAxisMax: number
  tableHeaders: TableHeader[]
  tableData: TableItem[]
}

type Props = {
  title: string
  titleId: string
  infoTitles: string[]
  chartId: string
  chartData: number[][]
  getFormatter: Function
  date: string
  labels: string[]
  dataLabels: string[] | TranslateResult[]
  tableLabels: string[] | TranslateResult[]
  unit: string
}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  Data,
  Methods,
  Computed,
  Props
> = {
  created() {
    this.canvas = process.browser
  },
  components: {
    DataView,
    DataViewTable,
    DataViewDataSetPanel,
    NotesExpansionPanel,
    ScrollableChart,
  },
  props: {
    title: {
      type: String,
      default: '',
    },
    titleId: {
      type: String,
      required: false,
      default: 'effective-reproduction-number',
    },
    infoTitles: {
      type: Array,
      required: false,
      default: () => [],
    },
    chartId: {
      type: String,
      default: 'effective-reproduction-number-chart',
    },
    chartData: {
      type: Array,
      required: false,
      default: () => [],
    },
    getFormatter: {
      type: Function,
      required: false,
      default: (_: number) => getNumberToLocaleStringFunction(),
    },
    date: {
      type: String,
      required: true,
      default: '',
    },
    labels: {
      type: Array,
      default: () => [],
    },
    dataLabels: {
      type: Array,
      default: () => [],
    },
    tableLabels: {
      type: Array,
      default: () => [],
    },
    unit: {
      type: String,
      default: '',
    },
  },
  data() {
    const colors: SurfaceStyle[] = [getGraphSeriesColor('E')]
    return {
      colors,
      canvas: true,
      yAxesBgPlugin,
    }
  },
  computed: {
    displayInfo() {
      const { lastDay, lastDayData, dayBeforeRatio } = calcDayBeforeRatio({
        displayData: this.displayData,
        dataIndex: 0,
        digit: 1,
      })
      return [
        {
          lText: lastDayData,
          sText: `${this.$t('{date} の数値', {
            date: this.$d(lastDay, 'dateWithoutYear'),
          })}（${this.$t('前日比')}: ${dayBeforeRatio} ${this.unit}）`,
          unit: this.unit,
        },
      ]
    },
    displayData() {
      return {
        labels: this.labels,
        datasets: [
          {
            type: 'line',
            label: this.dataLabels[0],
            data: this.chartData[0],
            pointBackgroundColor: 'rgba(180,100,100,0.8)',
            pointBorderColor: 'rgba(180,100,100,0.8)',
            pointRadius: 1.3,
            borderColor: this.colors[0].fillColor,
            borderWidth: 2,
            fill: false,
            order: 1,
            lineTension: 0.3,
          },
        ],
      }
    },
    tableHeaders() {
      return [
        { text: this.$t('日付'), value: 'text' },
        ...(this.tableLabels as string[]).map((text, i) => {
          return { text, value: `${i}`, align: 'end' }
        }),
      ]
    },
    tableData() {
      return this.labels
        .map((label, i) => {
          return Object.assign(
            { text: label },
            ...(this.tableLabels as string[]).map((_, j) => {
              return {
                [j]: this.getFormatter(j)(this.chartData[j][i]),
              }
            })
          )
        })
        .sort((a, b) => dayjs(a.text).unix() - dayjs(b.text).unix())
        .reverse()
    },
    displayOption() {
      const unit = this.unit
      const options: ChartJsAnnotationOptions = {
        tooltips: {
          displayColors: false,
          callbacks: {
            label: (tooltipItem) => {
              const cases = this.getFormatter(tooltipItem.datasetIndex!)(
                parseFloat(tooltipItem.value!)
              )
              return `${
                this.dataLabels[tooltipItem.datasetIndex!]
              } : ${cases} ${unit}`
            },
            title(tooltipItem, data) {
              if (tooltipItem[0].datasetIndex! < 2) {
                const date = data.labels![tooltipItem[0].index!].toString()
                return dayjs(date).format('M/D')
              }
              return ''
            },
          },
        },
        maintainAspectRatio: false,
        legend: {
          display: false,
        },
        scales: {
          xAxes: [
            {
              id: 'day',
              stacked: true,
              gridLines: {
                display: false,
              },
              ticks: {
                fontSize: 9,
                maxTicksLimit: 20,
                fontColor: '#808080',
                maxRotation: 0,
                callback: (label: string) => {
                  return dayjs(label).format('D')
                },
              },
              // #2384: If you set "type" to "time", make sure that the bars at both ends are not hidden.
              // #2384: typeをtimeに設定する時はグラフの両端が見切れないか確認してください
            },
            {
              id: 'month',
              stacked: true,
              gridLines: {
                drawOnChartArea: false,
                drawTicks: true,
                drawBorder: false,
                tickMarkLength: 10,
              },
              ticks: {
                fontSize: 11,
                fontColor: '#808080',
                padding: 3,
                fontStyle: 'bold',
              },
              type: 'time',
              time: {
                unit: 'month',
                displayFormats: {
                  month: 'MMM',
                },
              },
            },
          ],
          yAxes: [
            {
              id: 'effective-reproduction-number',
              position: 'left',
              gridLines: {
                display: true,
                drawOnChartArea: true,
                color: '#E5E5E5', // #E5E5E5
              },
              ticks: {
                suggestedMin: 0,
                maxTicksLimit: 8,
                fontColor: '#808080', // #808080
                min: 0,
                max: this.scaledTicksYAxisMax,
              },
            },
          ],
        },
        // ステージ3とステージ4に横線を引く
        annotation: {
          drawTime: 'afterDatasetsDraw',
          annotations: [
            {
              id: 'rt1', // optional
              type: 'line',
              mode: 'horizontal',
              scaleID: 'effective-reproduction-number',
              value: '1',
              borderColor: '#666',
              borderWidth: 1.5,
            },
          ],
        },
      }
      if (this.$route.query.ogp === 'true') {
        Object.assign(options, { animation: { duration: 0 } })
      }
      return options
    },
    displayDataHeader() {
      return {
        labels: ['2020-01-01'],
        datasets: (this.dataLabels as string[]).map((_) => ({
          data: [],
          backgroundColor: 'transparent',
          borderWidth: 0,
        })),
      }
    },
    displayOptionHeader() {
      const options: Chart.ChartOptions = {
        maintainAspectRatio: false,
        legend: {
          display: false,
        },
        tooltips: { enabled: false },
        scales: {
          xAxes: [
            {
              id: 'day',
              stacked: true,
              gridLines: {
                display: false,
              },
              ticks: {
                fontSize: 9,
                maxTicksLimit: 20,
                fontColor: 'transparent',
                maxRotation: 0,
                minRotation: 0,
                callback: (label: string) => dayjs(label).format('D'),
              },
            },
            {
              id: 'month',
              stacked: true,
              gridLines: {
                drawOnChartArea: false,
                drawTicks: false, // true -> false
                drawBorder: false,
                tickMarkLength: 10,
              },
              ticks: {
                fontSize: 11,
                fontColor: 'transparent', // #808080
                padding: 13, // 3 + 10(tickMarkLength)
                fontStyle: 'bold',
              },
              type: 'time',
              time: {
                unit: 'month',
              },
            },
          ],
          yAxes: [
            {
              type: 'linear',
              position: 'left',
              gridLines: {
                display: true,
                drawOnChartArea: false,
                color: '#E5E5E5', // #E5E5E5
              },
              ticks: {
                suggestedMin: 0,
                maxTicksLimit: 8,
                fontColor: '#808080', // #808080
                min: 0,
                max: this.scaledTicksYAxisMax,
              },
            },
          ],
        },
        animation: { duration: 0 },
      }
      return options
    },
    scaledTicksYAxisMax() {
      // return this.chartData.reduce((max, data) => {
      //   return Math.max(max, ...data.map((a) => Math.ceil(a))) + 10
      // }, 0)
      return 5
    },
  },
  mounted() {
    const lineChart = this.$refs.lineChart as Vue
    const lineElement = lineChart.$el
    const canvas = lineElement.querySelector('canvas')
    const labelledbyId = `${this.titleId}-graph`

    if (canvas) {
      canvas.setAttribute('role', 'img')
      canvas.setAttribute('aria-labelledby', labelledbyId)
    }
  },
}

export default Vue.extend(options)
</script>

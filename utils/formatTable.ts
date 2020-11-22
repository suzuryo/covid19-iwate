import Vue from 'vue'
import dayjs from 'dayjs'

type Header = {
  text: string
  value: string
  align?: string
}

const headers: Header[] = [
  { text: '通番', value: '通番' },
  { text: '陽性確定日', value: '陽性確定日' },
  { text: '発症日', value: '発症日' },
  { text: '居住地', value: '居住地' },
  { text: '年代', value: '年代' },
  // { text: '退院※', value: '退院', align: 'center' },
]

type DataType = {
  通番: string
  陽性確定日: string
  発症日: string
  居住地: string | null
  年代: string | null
  // 退院: '◯' | null
  [key: string]: any
}

type TableDataType = {
  通番: DataType['通番']
  陽性確定日: DataType['陽性確定日']
  発症日: DataType['発症日']
  居住地: DataType['居住地']
  年代: DataType['年代']
  // 退院: DataType['退院']
}

type TableDateType = {
  headers: Header[]
  datasets: TableDataType[]
}

/**
 * Format for DataTable component
 *
 * @param data - Raw data
 */
export default function (data: DataType[]): TableDateType {
  const datasets = data
    .map((d) => {
      const { url } = d
      const tsuban =
        url !== null
          ? `<a href="${url}" target="_blank">${d['通番']}</a>`
          : `${d['通番']}`
      const positiveConfirmedDate = d['陽性確定日']
        ? `${formatDateString(d['陽性確定日'])}`
        : '不明'
      const occurrenceConfirmedDateDiff = () => {
        if (d['無症状病原体保有者'] === true && d['発症日'] === null) {
          return '無症状'
        } else if (d['無症状病原体保有者'] === false && d['発症日'] === null) {
          return '不明'
        } else {
          return `${dayjs(d['陽性確定日']).diff(d['発症日'], 'day')}日前`
        }
      }
      return {
        通番: tsuban,
        陽性確定日: positiveConfirmedDate,
        発症日: occurrenceConfirmedDateDiff(),
        居住地: d['居住地'] ?? '調査中',
        年代: d['年代'] ?? '不明',
        // 退院: d['退院'],
      }
    })
    .sort((a, b) => dayjs(a.陽性確定日).unix() - dayjs(b.陽性確定日).unix())
    .reverse()
  return {
    headers,
    datasets,
  }
}

function formatDateString(date: string): string | undefined {
  const day = dayjs(date)
  if (day.isValid()) {
    return Vue.prototype.$nuxt.$options.i18n.d(day.toDate(), 'dateWithoutYear')
  }
}

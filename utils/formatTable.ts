import dayjs from 'dayjs'

type Header = {
  text: string
  value: string
  align?: string
}

const headers: Header[] = [
  { text: '通番', value: '通番' },
  { text: '確定日', value: '確定日' },
  { text: '発症日', value: '発症日' },
  { text: '居住地', value: '居住地' },
  { text: '年代', value: '年代' },
  { text: '📺', value: '📺' },
]

type DataType = {
  通番: string
  通番URL: string | null
  確定日: string
  発症日: string | null
  居住地: string | null
  年代: string | null
  会見URL: string | null
  [key: string]: any
}

type TableDataType = {
  通番: DataType['通番']
  通番URL: DataType['通番URL']
  確定日: DataType['確定日']
  発症日: DataType['発症日']
  居住地: DataType['居住地']
  年代: DataType['年代']
  会見URL: DataType['会見URL']
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
      const positiveConfirmedDate = d['陽性確定日'] ? d['陽性確定日'] : '不明'
      const occurrenceConfirmedDateDiff = () => {
        if (d['無症状病原体保有者'] === true && d['発症日'] === null) {
          return '無症状'
        } else if (d['無症状病原体保有者'] === false && d['発症日'] === null) {
          return '不明'
        } else if (d['確定日'] === null || d['発症日'] == null) {
          return '不明'
        } else {
          return `${dayjs(d['確定日']).diff(d['発症日'], 'day')}日前`
        }
      }
      return {
        通番: d['通番'],
        通番URL: d.url,
        確定日: positiveConfirmedDate,
        発症日: occurrenceConfirmedDateDiff(),
        居住地: d['居住地'] ?? '調査中',
        年代: d['年代'] ?? '不明',
        会見URL: d['会見'],
      }
    })
    .sort((a, b) => dayjs(a['確定日']).unix() - dayjs(b['確定日']).unix())
    .reverse()
  return {
    headers,
    datasets,
  }
}

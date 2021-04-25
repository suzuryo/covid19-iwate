import { TranslateResult } from 'vue-i18n'

type Cities = {
  [key: string]: {
    count: number
    area: string
  }
}

type MapDataItem = {
  area: TranslateResult
  count: number
  label: TranslateResult
  last7days: number
  ruby: TranslateResult
}

type MapData = MapDataItem[]

<template>
  <v-col id="WhatsNewCard" cols="12" md="6" class="DataCard">
    <client-only>
      <whats-new
        :title="$t('最新のお知らせ')"
        :title-id="'whats-new'"
        :date="date"
        :items="newsItems.newsItems"
      />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import dayjs from 'dayjs'
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

import WhatsNew from '@/components/WhatsNew.vue'
import Data from '@/data/news.json'

type NewsItem = {
  date: string
  icon: string
  text: string
  url: string
}

type NewsItems = {
  newsItems: NewsItem[]
}

type Methods = {}
type Computed = {}
type Props = {}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  NewsItems,
  Methods,
  Computed,
  Props
> = {
  components: {
    WhatsNew,
  },
  data() {
    // 日付の新しいものが上
    const newsItems: any = {
      newsItems: [],
    }

    newsItems.newsItems = Data.newsItems
      .sort((a, b) => {
        return dayjs(a.date).isBefore(dayjs(b.date)) ? 1 : -1
      })
      .map((d: any) => {
        const _locale: string = this.$i18n.locale
        const _date: string = this.$d(dayjs(d.date).toDate(), 'dateWithoutYear')
        const _icon: string = d.icon
        const _text: string = d.text[_locale] ?? d.text.ja
        const _url: string = d.url[_locale] ?? d.url.ja

        return {
          date: _date,
          icon: _icon,
          text: _text,
          url: _url,
        }
      })

    const date = dayjs(
      Data.newsItems.sort((a, b) => {
        return dayjs(a.date).isBefore(dayjs(b.date)) ? 1 : -1
      })[0].date
    ).format()

    return {
      newsItems,
      date,
    }
  },
}

export default Vue.extend(options)
</script>

<template>
  <v-col id="SelfDisclosuresCard" cols="12" :md="md" class="DataCard">
    <client-only>
      <self-disclosures
        :title="$t('SelfDisclosuresCard.title')"
        :title-id="'self-disclosures'"
        :date="date"
        :items="newsItems.newsItems"
      >
        <template #notes>
          <ul>
            <li v-for="note in $t('SelfDisclosuresCard.notes')" :key="note">
              {{ note }}
            </li>
          </ul>
        </template>
      </self-disclosures>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import dayjs from 'dayjs'
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

import AppLink from '@/components/AppLink.vue'
import SelfDisclosures from '@/components/SelfDisclosures.vue'
import Data from '@/data/self_disclosures.json'

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
    AppLink,
    SelfDisclosures,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
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

<style lang="scss" scoped>
.self_disclosure_form {
  margin-top: 1rem;
  text-align: right;
}
</style>

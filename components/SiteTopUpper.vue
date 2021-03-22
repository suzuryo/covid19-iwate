<template>
  <div class="MainPage">
    <div class="Header mb-3">
      <page-header :icon-path="headerItem.iconPath">
        <template #pageHeader>
          {{ headerItem.title }}
        </template>
      </page-header>
      <div class="UpdatedAt">
        <span>{{ $t('SiteTopUpper.最終更新') }}</span>
        <time :datetime="updatedAt">{{ formattedDateForDisplay }}</time>
      </div>
      <div v-show="!['ja'].includes($i18n.locale)" class="Annotation">
        <span>{{ $t('SiteTopUpper.注釈') }}</span>
      </div>
    </div>
    <lazy-static-info
      class="mb-4"
      :url="localePath('/flow')"
      :text="$t('SiteTopUpper.電話相談をどうぞ')"
      :btn-text="$t('SiteTopUpper.相談の手順を見る')"
    />
    <lazy-static-info
      v-for="(item, i) in alertItems"
      :key="i"
      class="mb-4"
      :url="item.url"
      :text="item.text"
    />
  </div>
</template>

<script lang="ts">
import { mdiChartTimelineVariant } from '@mdi/js'
import dayjs from 'dayjs'
import Vue from 'vue'

import PageHeader from '@/components/PageHeader.vue'
import Alert from '@/data/alert.json'
import Data from '@/data/data.json'
import { convertDatetimeToISO8601Format } from '@/utils/formatDate'

export default Vue.extend({
  components: {
    PageHeader,
  },
  data() {
    const { lastUpdate } = Data

    // 日付の新しいものが上
    const alertItems = Alert.alertItems
      .sort((a, b) => {
        return dayjs(a.date).isBefore(dayjs(b.date)) ? 1 : -1
      })
      .map((d: any) => {
        const _locale: string = this.$i18n.locale
        const _text: string = d.text[_locale] ?? d.text.ja
        const _url: string = d.url[_locale] ?? d.url.ja

        return {
          text: _text,
          url: _url,
        }
      })

    return {
      headerItem: {
        iconPath: mdiChartTimelineVariant,
        title: this.$t('Common.岩手の最新感染動向'),
      },
      lastUpdate,
      alertItems,
    }
  },
  computed: {
    updatedAt() {
      return convertDatetimeToISO8601Format(this.$data.lastUpdate)
    },
    formattedDateForDisplay() {
      return `${this.$d(new Date(this.$data.lastUpdate), 'dateTime')} JST`
    },
  },
})
</script>

<style lang="scss" scoped>
.MainPage {
  .Header {
    display: flex;
    flex-wrap: wrap;
    align-items: flex-end;

    @include lessThan($small) {
      flex-direction: column;
      align-items: baseline;
    }
  }

  .UpdatedAt {
    @include font-size(14);

    color: $gray-3;
    margin-bottom: 0.2rem;
  }

  .Annotation {
    @include font-size(12);

    color: $gray-3;
    @include largerThan($small) {
      margin: 0 0 0 auto;
    }
  }
}
</style>

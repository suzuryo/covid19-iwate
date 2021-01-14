<template>
  <div class="MainPage">
    <div class="Header mb-3">
      <page-header :icon-path="headerItem.iconPath">
        <template #pageHeader>
          {{ headerItem.title }}
        </template>
      </page-header>
      <div class="UpdatedAt">
        <span>{{ $t('最終更新') }}</span>
        <time :datetime="updatedAt">{{ formattedDateForDisplay }}</time>
      </div>
      <div v-show="!['ja'].includes($i18n.locale)" class="Annotation">
        <span>{{ $t('注釈') }}</span>
      </div>
    </div>
    <lazy-static-info
      class="mb-4"
      :url="localePath('/flow')"
      :text="$t('自分や家族の症状に不安や心配があればまずは電話相談をどうぞ')"
      :btn-text="$t('相談の手順を見る')"
    />
    <lazy-static-info
      class="mb-4"
      text="日本国内の感染者数は31万人、これは盛岡市の人口29万人より多い"
    />
  </div>
</template>

<script lang="ts">
import { mdiChartTimelineVariant } from '@mdi/js'
import Vue from 'vue'
import { MetaInfo } from 'vue-meta'

import PageHeader from '@/components/PageHeader.vue'
import Data from '@/data/data.json'
import { convertDatetimeToISO8601Format } from '@/utils/formatDate'

export default Vue.extend({
  components: {
    PageHeader,
  },
  data() {
    const { lastUpdate } = Data

    return {
      headerItem: {
        iconPath: mdiChartTimelineVariant,
        title: this.$t('Common.岩手の最新感染動向'),
      },
      lastUpdate,
    }
  },
  head(): MetaInfo {
    return {
      title: this.$t('Common.岩手の最新感染動向') as string,
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

<template>
  <div class="SiteTopUpper">
    <v-lazy>
      <transition-group>
        <static-info
          :key="$t('SiteTopUpper.電話相談をどうぞ')"
          class="mb-4"
          :url="localePath('/flow')"
          :text="$t('SiteTopUpper.電話相談をどうぞ')"
          :btn-text="$t('SiteTopUpper.相談の手順を見る')"
        />
        <static-info
          v-for="item in alertItems"
          :key="item.text"
          class="mb-4 alertItem"
          :url="item.url"
          :text="item.text"
        />
      </transition-group>
    </v-lazy>
  </div>
</template>

<script lang="ts">
import { mdiChartTimelineVariant } from '@mdi/js'
import Vue from 'vue'

import StaticInfo from '@/components/index/SiteTopUpper/StaticInfo.vue'
import Alert from '@/data/alert.json'

export default Vue.extend({
  components: {
    StaticInfo,
  },
  data() {
    // 日付でソートしない
    // Google Sheets の行の順番で上から並ぶ
    const alertItems = Alert.alertItems.map((d: any) => {
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
      alertItems,
    }
  },
})
</script>

<template>
  <div>
    <page-header
      :icon-path="headerItem.iconPath"
      :title="headerItem.title"
      :updated-at="lastUpdateAsString"
    />
    <site-top-upper />
    <v-lazy>
      <cards-tab />
    </v-lazy>
  </div>
</template>

<script lang="ts">
import { mdiChartTimelineVariant } from '@mdi/js'
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'
import { MetaInfo } from 'vue-meta'

import PageHeader from '@/components/_shared/PageHeader.vue'
import CardsTab from '@/components/index/CardsTab.vue'
import SiteTopUpper from '@/components/index/SiteTopUpper.vue'
import { lastUpdate } from '@/data/data.json'

type Data = {
  headerItem: {
    iconPath: string
    title: string
  }
  lastUpdate: string
}
type Methods = {}
type Computed = {
  lastUpdateAsString: string
}
type Props = {}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  Data,
  Methods,
  Computed,
  Props
> = {
  components: {
    CardsTab,
    PageHeader,
    SiteTopUpper,
  },
  data() {
    return {
      lastUpdate,
      headerItem: {
        iconPath: mdiChartTimelineVariant,
        title: this.$t('Common.岩手の最新感染動向') as string,
      },
    }
  },
  computed: {
    lastUpdateAsString() {
      return this.lastUpdate
    },
  },
  head(): MetaInfo {
    return {
      title: this.$t('Common.岩手の最新感染動向') as string,
    }
  },
}

export default options
</script>

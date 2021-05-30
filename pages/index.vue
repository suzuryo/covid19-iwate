<template>
  <div>
    <site-top-upper />
    <v-lazy>
      <cards-tab />
    </v-lazy>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'
import { MetaInfo } from 'vue-meta'

import CardsTab from '@/components/index/CardsTab.vue'
import SiteTopUpper from '@/components/index/SiteTopUpper.vue'

type Data = {}
type Methods = {}
type Computed = {}
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
    SiteTopUpper,
  },
  head(): MetaInfo {
    return {
      title: this.$t('Common.岩手の最新感染動向') as string,
    }
  },
}

export default options
</script>

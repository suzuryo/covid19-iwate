<template>
  <div>
    <site-top-upper />
    <cards-reference />
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import SiteTopUpper from '@/components/SiteTopUpper.vue'
import CardsReference from '@/components/CardsReference.vue'
import { mdiChartTimelineVariant } from '@mdi/js'

export default Vue.extend({
  components: {
    SiteTopUpper,
    CardsReference,
  },
  data() {
    return {
      mdiChartTimelineVariant,
    }
  },
})
</script>

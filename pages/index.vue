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
import { EventBus, TOGGLE_EVENT } from '@/utils/tab-event-bus.ts'
import { mdiChartTimelineVariant } from '@mdi/js'

export default Vue.extend({
  components: {
    SiteTopUpper,
    CardsReference,
  },
  data() {
    return {
      tab: null,
      mdiChartTimelineVariant,
    }
  },
  methods: {
    change() {
      EventBus.$emit(TOGGLE_EVENT)
    },
  },
})
</script>

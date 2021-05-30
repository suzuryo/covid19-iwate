<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'
import SelfDisclosuresCard from '@/components/index/CardsReference/SelfDisclosures/Card.vue' // 自主公表
import WhatsNewCard from '@/components/index/CardsReference/WhatsNew/Card.vue' // 最新のお知らせ

export default Vue.extend({
  components: {
    CardsLazyRow,
  },
  data() {
    return {
      rows: [[WhatsNewCard, SelfDisclosuresCard]],
    }
  },
})
</script>

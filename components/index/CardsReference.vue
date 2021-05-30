<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import SelfDisclosuresCard from '@/components/cards/SelfDisclosuresCard.vue' // 自主公表
import WhatsNewCard from '@/components/cards/WhatsNewCard.vue' // 最新のお知らせ
import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'

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

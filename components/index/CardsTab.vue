<template>
  <client-only>
    <v-tabs v-model="tab" hide-slider>
      <v-tab
        v-for="(item, i) in items"
        :key="i"
        v-ripple="false"
        :href="`#tab-${i}`"
        @click="change"
      >
        <v-icon class="TabIcon">{{ mdiChartTimelineVariant }}</v-icon>
        {{ item.label }}
      </v-tab>
      <v-tabs-items v-model="tab" touchless>
        <v-tab-item v-for="(item, i) in items" :key="i" :value="`tab-${i}`">
          <lazy-component :is="item.component" />
        </v-tab-item>
      </v-tabs-items>
    </v-tabs>
  </client-only>
</template>

<script lang="ts">
import { mdiChartTimelineVariant } from '@mdi/js'
import Vue from 'vue'

import CardsReference from '@/components/CardsReference.vue'
import CardsMonitoring from '@/components/index/CardsMonitoring.vue'
import { EventBus, TOGGLE_EVENT } from '@/utils/tab-event-bus'

export default Vue.extend({
  components: {
    CardsMonitoring,
    CardsReference,
  },
  data() {
    return {
      tab: null,
      items: [
        {
          label: this.$t('Common.モニタリング項目'),
          component: CardsMonitoring,
        },
        {
          label: this.$t('Common.お知らせ・参考資料'),
          component: CardsReference,
        },
      ],
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

<style lang="scss">
.v-window {
  overflow: visible !important;
}

.v-slide-group__content {
  border-bottom: 1px solid $green-1;
  background: $gray-5;
}

.v-tab {
  top: 1px;
  margin: 0 8px;
  border-style: solid;
  border-radius: 4px 4px 0 0;
  font-weight: bold !important;
  background: $gray-5;
  @include font-size(16, true);
  &:hover {
    background-color: $green-1;
    color: $white !important;
  }
  &::before {
    background-color: transparent !important;
  }

  &--active {
    color: $green-1 !important;
    border-color: $green-1 $green-1 $gray-5 $green-1;
    border-width: 1px 1px 0 1px;
    &:hover {
      border-color: $green-1 $green-1 $gray-5 $green-1;
    }
    &::before {
      background-color: transparent;
    }
  }

  &:not(.v-tab--active) {
    color: $gray-3 !important;
    border-color: $gray-3 $gray-3 $green-1 $gray-3;
    border-width: 1px 1px 1px 1px;
    &:hover {
      color: $white !important;
    }
    .TabIcon {
      color: inherit !important;
    }
  }
}
.v-tabs-items {
  background-color: transparent !important;
}

@function px2vw($px, $vw: 768) {
  @return $px / $vw * 100vw;
}

@include lessThan($medium) {
  .v-slide-group__content {
    width: 100%;
  }
  .v-tab {
    font-size: px2vw(16) !important;
    font-weight: normal !important;
    flex: 1 1 auto;
    width: 100%;
    padding: 0 8px !important;
  }
}

@include lessThan($small) {
  .v-tab {
    font-size: px2vw(20, 600) !important;
    padding: 0 4px !important;
  }
  .TabIcon {
    font-size: px2vw(24, 600) !important;
  }
}
</style>

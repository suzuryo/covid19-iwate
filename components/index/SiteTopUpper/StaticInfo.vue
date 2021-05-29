<template>
  <app-link :to="url" :show-icon="false" class="StaticInfo">
    {{ text }}
    <div v-if="btnText" class="StaticInfo-Button">
      <button>
        {{ btnText }}
      </button>
    </div>
  </app-link>
</template>

<script lang="ts">
import Vue from 'vue'

import AppLink from '@/components/_shared/AppLink.vue'

export default Vue.extend({
  components: { AppLink },
  props: {
    url: {
      type: String,
      default: '',
      required: true,
    },
    text: {
      type: String,
      default: '',
      required: true,
    },
    btnText: {
      type: String,
      default: '',
    },
  },
})
</script>

<style lang="scss">
.StaticInfo {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  background-color: $white;
  border: 1px solid $gray-4;
  box-shadow: $shadow;
  border-radius: 4px;
  padding: 0.5em 1em;

  @include text-link();

  &-Button {
    flex: 1 0 auto;
    text-align: right;

    > button {
      @include button-text('sm');
    }

    @include lessThan($small) {
      margin-top: 4px;
    }
  }
}
</style>

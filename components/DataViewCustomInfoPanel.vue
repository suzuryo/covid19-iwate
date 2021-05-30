<template>
  <div class="DataView-DataInfo">
    <i18n tag="small" class="DataView-DataInfo-summary-unit" :path="lText">
      <template #num>
        <span class="DataView-DataInfo-summary">
          {{ num }}
        </span>
      </template>
    </i18n>
    <small class="DataView-DataInfo-date">{{ sText }}</small>
  </div>
</template>

<script lang="ts">
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'
export default DataViewDataSetPanel.extend({
  props: {
    lText: {
      type: String,
      default: '{num}',
    },
    num: {
      type: String,
      default: '',
    },
  },
})
</script>

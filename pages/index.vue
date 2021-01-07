<template>
  <div>
    <LazySiteTopUpper />
    <LazyCardsTab />
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

type Data = {
  showCardsTab: boolean
}
type Methods = {
  onScroll: () => void
}
type Computed = {}
type Props = {}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  Data,
  Methods,
  Computed,
  Props
> = {
  name: 'Index',
  data() {
    return {
      showCardsTab: false,
    }
  },
}

export default options
</script>

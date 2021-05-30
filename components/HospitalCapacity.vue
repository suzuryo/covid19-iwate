<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <div class="Beds">
      <div
        v-for="bed in bedSummary.beds"
        :key="bed"
        :class="bedInUse(bed)"
        :title="bed + 1"
      >
        <span v-if="bed % 50 === 49">{{ bed + 1 }}</span>
      </div>
    </div>
    <div class="legend1">
      <div>
        <span class="Bed inuse" />
        {{ $t('HospitalCapacityCard.入院中') }}
      </div>
      <div>
        <span class="Bed waiting" />
        {{ $t('HospitalCapacityCard.入院療養等調整中') }}
      </div>
      <div>
        <span class="Bed" />
        {{ $t('HospitalCapacityCard.空き') }}
      </div>
    </div>
    <div class="legend2">
      <div>
        <span class="Bed phase2" />
        {{ $t('HospitalCapacityCard.phase2') }}
      </div>
      <div>
        <span class="Bed phase3" />
        {{ $t('HospitalCapacityCard.phase3') }}
      </div>
      <div v-if="bedSummary.hospital + bedSummary.waiting > 350">
        <span class="Bed overflowed" />
        {{ $t('HospitalCapacityCard.overflowed') }}
      </div>
    </div>
    <template #notes>
      <notes-expansion-panel
        class="DataView-ExpansionPanel"
        :expansion-panel-text="$t('Common.注')"
      >
        <template #notes>
          <slot name="notes" />
        </template>
      </notes-expansion-panel>
    </template>
    <template #dataSetPanel>
      <data-view-data-set-panel
        :title="$t('HospitalCapacityCard.title')"
        :card-path="`/cards/${titleId}/`"
      />
    </template>
  </data-view>
</template>

<script lang="ts">
import Vue from 'vue'

import DataView from '@/components/index/_shared/DataView.vue'
import DataViewDataSetPanel from '@/components/index/_shared/DataViewDataSetPanel.vue'
import NotesExpansionPanel from '@/components/NotesExpansionPanel.vue'

export default Vue.extend({
  components: {
    DataView,
    DataViewDataSetPanel,
    NotesExpansionPanel,
  },
  props: {
    title: {
      type: String,
      default: '',
    },
    titleId: {
      type: String,
      default: '',
    },
    date: {
      type: String,
      default: '',
    },
    bedSummary: {
      type: Object,
      default: () => {},
    },
  },
  methods: {
    bedInUse(bed: number): string {
      const classes = ['Bed']
      // 入院の数
      const hospital = this.bedSummary.hospital
      // 調整中の数
      const waiting = this.bedSummary.waiting
      // Phase2の最大病床数
      const bedsPhase2 = 250
      // Phase3の最大病床数
      const bedsPhase3 = 350

      // ベッド使用中
      if (bed < hospital) {
        classes.push('inuse')
      }

      // 調整中
      if (bed >= hospital && bed < hospital + waiting) {
        classes.push('waiting')
      }

      // Phase2で確保されたベッド
      if (bed < bedsPhase2) {
        classes.push('phase2')
      }

      // Phase3で確保されるベッド
      if (bed >= bedsPhase2 && bed < bedsPhase3) {
        classes.push('phase3')
      }

      // Phase3で確保したベッド以上のベッド
      if (bed >= bedsPhase3) {
        classes.push('overflowed')
      }

      return classes.join(' ')
    },
  },
})
</script>

<style lang="scss" scoped>
.Beds {
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  flex-wrap: wrap;
}
$bed_size: 16px;
.Bed {
  display: inline-block;
  vertical-align: middle;
  width: $bed_size;
  height: $bed_size;
  margin-right: 3px;
  margin-bottom: 3px;
  border: 1px solid #aaa;
  background-color: #fff;
  > span {
    display: inline-block;
    line-height: $bed_size - 2px;
    height: $bed_size - 2px;
    width: $bed_size - 2px;
    text-align: center;
    font-family: 'Helvetica', 'Arial', sans-serif;
    letter-spacing: 0;
    @include font-size(7);
  }
  &.phase2 {
    opacity: 1;
  }
  &.phase3 {
    border-style: dotted;
  }
  &.inuse {
    background-color: #fce5da;
  }
  &.waiting {
    background-color: #fff8bf;
  }
  &.overflowed {
    border: 1px solid #f99;
  }
}
.legend1 {
  display: flex;
  @include font-size(12);
  > div {
    margin: 20px 20px 20px 0;
    flex-wrap: wrap;
  }
}
.legend2 {
  display: flex;
  flex-direction: column;
  @include font-size(12);
  > div {
    margin: 1px 0;
    flex-wrap: wrap;
  }
}
</style>

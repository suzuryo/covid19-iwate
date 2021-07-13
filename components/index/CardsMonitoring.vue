<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/index/_shared/CardsLazyRow.vue'
import ConfirmedCasesAttributesCard from '@/components/index/CardsMonitoring/ConfirmedCasesAttributes/Card.vue' // 陽性者の属性
import ConfirmedCasesByMunicipalitiesCard from '@/components/index/CardsMonitoring/ConfirmedCasesByMunicipalities/Card.vue' // 陽性患者数（市町村別）
import ConfirmedCasesDetailsCard from '@/components/index/CardsMonitoring/ConfirmedCasesDetails/Card.vue' // 検査陽性者の状況
import ConfirmedCasesNumberCard from '@/components/index/CardsMonitoring/ConfirmedCasesNumber/Card.vue' // 報告日別による陽性者数の推移
import EffectiveReproductionNumberCard from '@/components/index/CardsMonitoring/EffectiveReproductionNumber/Card.vue' // 実効再生産数
import HospitalCapacityCard from '@/components/index/CardsMonitoring/HospitalCapacity/Card.vue' // 入院病床の状況
import HospitalizedNumberCard from '@/components/index/CardsMonitoring/HospitalizedNumber/Card.vue' // 入院と宿泊療養の推移
import HotelCapacityCard from '@/components/index/CardsMonitoring/HotelCapacity/Card.vue' // 宿泊療養の状況
import MonitoringConfirmedCasesNumberCard from '@/components/index/CardsMonitoring/MonitoringConfirmedCasesNumber/Card.vue' // 新規陽性者数の7日間移動平均
import MonitoringConfirmedCasesNumberPer100kCard from '@/components/index/CardsMonitoring/MonitoringConfirmedCasesNumberPer100k/Card.vue' // 新規陽性者数の7日間移動平均対人口10万人
import PositiveRateCard from '@/components/index/CardsMonitoring/PositiveRate/Card.vue' // 検査の陽性率・PCR検査の7日間移動平均
import TestedNumberCard from '@/components/index/CardsMonitoring/TestedNumber/Card.vue' // 検査実施件数
import UntrackedRateCard from '@/components/index/CardsMonitoring/UntrackedRate/Card.vue' // 接触歴等不明者数(7日間移動平均)・前週比
import WeeklyMapCard from '@/components/index/CardsMonitoring/WeeklyMap/Card.vue' // 直近1週間の陽性例マップ

export default Vue.extend({
  components: {
    CardsLazyRow,
  },
  data() {
    return {
      rows: [
        [ConfirmedCasesDetailsCard, WeeklyMapCard],
        [
          MonitoringConfirmedCasesNumberPer100kCard,
          EffectiveReproductionNumberCard,
        ],
        [ConfirmedCasesNumberCard, MonitoringConfirmedCasesNumberCard],
        [HospitalCapacityCard, HotelCapacityCard],
        [HospitalizedNumberCard, UntrackedRateCard],
        [ConfirmedCasesAttributesCard, ConfirmedCasesByMunicipalitiesCard],
        [PositiveRateCard, TestedNumberCard]
      ],
    }
  },
})
</script>

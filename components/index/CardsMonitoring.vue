<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
import Vue from 'vue'

import CardsLazyRow from '@/components/_shared/CardsLazyRow.vue'
import ConfirmedCasesAttributesCard from '@/components/cards/ConfirmedCasesAttributesCard.vue' // 陽性者の属性
import ConfirmedCasesByMunicipalitiesCard from '@/components/cards/ConfirmedCasesByMunicipalitiesCard.vue' // 陽性患者数（市町村別）
import ConfirmedCasesDetailsCard from '@/components/cards/ConfirmedCasesDetailsCard.vue' // 検査陽性者の状況
import ConfirmedCasesNumberCard from '@/components/cards/ConfirmedCasesNumberCard.vue' // 報告日別による陽性者数の推移
import HospitalCapacityCard from '@/components/cards/HospitalCapacityCard.vue' // 入院病床の状況
import HospitalizedNumberCard from '@/components/cards/HospitalizedNumberCard.vue' // 入院と宿泊療養の推移
import HotelCapacityCard from '@/components/cards/HotelCapacityCard.vue' // 宿泊療養の状況
import MonitoringConfirmedCasesNumberCard from '@/components/cards/MonitoringConfirmedCasesNumberCard.vue' // 新規陽性者数の7日間移動平均
import MonitoringConfirmedCasesNumberPer100kCard from '@/components/cards/MonitoringConfirmedCasesNumberPer100kCard.vue' // 新規陽性者数の7日間移動平均対人口10万人
import TestedNumberCard from '@/components/cards/TestedNumberCard.vue' // 検査実施件数
import UntrackedRateCard from '@/components/cards/UntrackedRateCard.vue' // 接触歴等不明者数(7日間移動平均)・前週比
import WeeklyMapCard from '@/components/cards/WeeklyMapCard.vue' // 直近1週間の陽性例マップ
import PositiveRateCard from '~/components/cards/PositiveRateCard.vue' // 検査の陽性率・PCR検査の7日間移動平均
// import SevereCaseCard from '@/components/cards/SevereCaseCard.vue' // 重症患者数
// import PositiveNumberByDiagnosedDateCard from '@/components/cards/PositiveNumberByDiagnosedDateCard.vue' // 確定日別による陽性者数の推移

export default Vue.extend({
  components: {
    CardsLazyRow,
  },
  data() {
    return {
      rows: [
        [MonitoringConfirmedCasesNumberPer100kCard],
        [ConfirmedCasesDetailsCard, MonitoringConfirmedCasesNumberCard],
        [HospitalizedNumberCard, WeeklyMapCard],
        [HospitalCapacityCard, HotelCapacityCard],
        [ConfirmedCasesAttributesCard, ConfirmedCasesByMunicipalitiesCard],
        [ConfirmedCasesNumberCard, UntrackedRateCard],
        [PositiveRateCard, TestedNumberCard],
      ],
    }
  },
})
</script>

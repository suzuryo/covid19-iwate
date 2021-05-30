<template>
  <cards-lazy-row :rows="rows" />
</template>

<script lang="ts">
/* eslint-disable simple-import-sort/imports -- ブラウザでの表示順に合わせて各 card の component を import する */
import Vue from 'vue'

import CardsLazyRow from '@/components/_shared/CardsLazyRow.vue'

// 検査陽性者の状況
const ConfirmedCasesDetailsCard = () =>
  import('@/components/cards/ConfirmedCasesDetailsCard.vue')
// 報告日別による陽性者数の推移
const ConfirmedCasesNumberCard = () =>
  import('@/components/cards/ConfirmedCasesNumberCard.vue')
// 新規陽性者数の7日間移動平均
const MonitoringConfirmedCasesNumberCard = () =>
  import('@/components/cards/MonitoringConfirmedCasesNumberCard.vue')
// 新規陽性者数の7日間移動平均
const MonitoringConfirmedCasesNumberPer100kCard = () =>
  import('@/components/cards/MonitoringConfirmedCasesNumberPer100kCard.vue')
// 接触歴等不明者数(7日間移動平均)・前週比
const UntrackedRateCard = () =>
  import('@/components/cards/UntrackedRateCard.vue')
// 検査の陽性率・PCR検査の7日間移動平均
const PositiveRateCard = () => import('@/components/cards/PositiveRateCard.vue')
// 入院と宿泊療養の推移
const HospitalizedNumberCard = () =>
  import('@/components/cards/HospitalizedNumberCard.vue')
// 入院病床の状況
const HospitalCapacityCard = () =>
  import('@/components/cards/HospitalCapacityCard.vue')
// 宿泊療養の状況
const HotelCapacityCard = () =>
  import('@/components/cards/HotelCapacityCard.vue')
// 陽性者の属性
const ConfirmedCasesAttributesCard = () =>
  import('@/components/cards/ConfirmedCasesAttributesCard.vue')
// 陽性患者数（市町村別）
const ConfirmedCasesByMunicipalitiesCard = () =>
  import('@/components/cards/ConfirmedCasesByMunicipalitiesCard.vue')
// 検査実施件数
const TestedNumberCard = () => import('@/components/cards/TestedNumberCard.vue')
const WeeklyMapCard = () => import('@/components/cards/WeeklyMapCard.vue')
// // 重症患者数
// const SevereCaseCard = () => import('@/components/cards/SevereCaseCard.vue')
// // 確定日別による陽性者数の推移
// const PositiveNumberByDiagnosedDateCard = () =>
//   import('@/components/cards/PositiveNumberByDiagnosedDateCard.vue')
/* eslint-enable simple-import-sort/imports */

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

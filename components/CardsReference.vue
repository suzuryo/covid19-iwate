<template>
  <div>
    <card-row class="DataBlock">
      <!-- 最新のお知らせ -->
      <whats-new-card />
      <!-- 自主公表 -->
      <self-disclosures-card />
      <!-- 検査陽性者の状況 -->
      <confirmed-cases-details-card />
      <!-- 新規患者に関する報告件数の推移 -->
      <confirmed-cases-number-card />
      <!-- 新規陽性者数 -->
      <monitoring-confirmed-cases-number-card />
      <!-- 新規陽性者における接触歴等不明者数 -->
      <untracked-rate-card />
      <!-- 検査の陽性率・検査件数 -->
      <positive-rate-card />
      <!-- 入院患者数 -->
      <hospitalized-number-card />
      <!-- 陽性者の属性 -->
      <confirmed-cases-attributes-card />
      <!-- 市町村別患者数 -->
      <confirmed-cases-by-municipalities-card />
      <!-- 検査実施件数 -->
      <tested-number-card />
      <!-- 受診・相談センター 受付件数 -->
      <monitoring-consultation-desk-reports-number-card />
      <!-- 一般相談 受付件数 -->
      <telephone-advisory-reports-number-card />
      <!-- 重症患者数 -->
      <!-- <severe-case-card /> -->
      <!-- 発症日別による陽性者数の推移 -->
      <!-- <positive-number-by-developed-date-card /> -->
      <!-- 確定日別による陽性者数の推移 -->
      <!-- <positive-number-by-diagnosed-date-card /> --><!-- 1日あたりの感染者が増えたら機能するが現在はあまり意味のない数字なので非表示 -->
    </card-row>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import CardRow from '@/components/cards/CardRow.vue'
import WhatsNewCard from '@/components/cards/WhatsNewCard.vue'
import SelfDisclosuresCard from '@/components/cards/SelfDisclosuresCard.vue'
import ConfirmedCasesDetailsCard from '@/components/cards/ConfirmedCasesDetailsCard.vue'
import ConfirmedCasesNumberCard from '@/components/cards/ConfirmedCasesNumberCard.vue'
import MonitoringConfirmedCasesNumberCard from '@/components/cards/MonitoringConfirmedCasesNumberCard.vue'
import PositiveRateCard from '@/components/cards/PositiveRateCard.vue'
import UntrackedRateCard from '@/components/cards/UntrackedRateCard.vue'
import HospitalizedNumberCard from '@/components/cards/HospitalizedNumberCard.vue'
import ConfirmedCasesAttributesCard from '@/components/cards/ConfirmedCasesAttributesCard.vue'
import ConfirmedCasesByMunicipalitiesCard from '@/components/cards/ConfirmedCasesByMunicipalitiesCard.vue'
import TestedNumberCard from '@/components/cards/TestedNumberCard.vue'
import TelephoneAdvisoryReportsNumberCard from '@/components/cards/TelephoneAdvisoryReportsNumberCard.vue'
import MonitoringConsultationDeskReportsNumberCard from '@/components/cards/MonitoringConsultationDeskReportsNumberCard.vue'
// import SevereCaseCard from '@/components/cards/SevereCaseCard.vue'
// import PositiveNumberByDevelopedDateCard from '@/components/cards/PositiveNumberByDevelopedDateCard.vue'
// import PositiveNumberByDiagnosedDateCard from '@/components/cards/PositiveNumberByDiagnosedDateCard.vue'

export default Vue.extend({
  components: {
    CardRow,
    WhatsNewCard,
    SelfDisclosuresCard,
    MonitoringConfirmedCasesNumberCard,
    UntrackedRateCard,
    PositiveRateCard,
    ConfirmedCasesDetailsCard,
    ConfirmedCasesNumberCard,
    HospitalizedNumberCard,
    ConfirmedCasesAttributesCard,
    ConfirmedCasesByMunicipalitiesCard,
    TestedNumberCard,
    MonitoringConsultationDeskReportsNumberCard,
    TelephoneAdvisoryReportsNumberCard,
    // SevereCaseCard,
    // PositiveNumberByDevelopedDateCard,//
    // PositiveNumberByDiagnosedDateCard,//
  },
})
</script>

<style lang="scss" scoped>
.DataBlock {
  margin: 20px -8px;

  .DataCard {
    @include largerThan($medium) {
      padding: 10px;
    }

    @include lessThan($small) {
      padding: 4px 8px;
    }
  }
}
</style>

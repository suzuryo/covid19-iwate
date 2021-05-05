<template>
  <component :is="cardComponent" md="12">
    <template #breadCrumb>
      <breadcrumb :items="breadCrumb.items" />
    </template>
  </component>
</template>

<script>
import Breadcrumb from '@/components/Breadcrumb.vue'
import ConfirmedCasesAttributesCard from '@/components/cards/ConfirmedCasesAttributesCard.vue'
import ConfirmedCasesByMunicipalitiesCard from '@/components/cards/ConfirmedCasesByMunicipalitiesCard.vue'
import ConfirmedCasesDetailsCard from '@/components/cards/ConfirmedCasesDetailsCard.vue'
import ConfirmedCasesNumberCard from '@/components/cards/ConfirmedCasesNumberCard.vue'
// import SevereCaseCard from '@/components/cards/SevereCaseCard.vue'
import HospitalizedNumberCard from '@/components/cards/HospitalizedNumberCard.vue'
import MonitoringConfirmedCasesNumberCard from '@/components/cards/MonitoringConfirmedCasesNumberCard.vue'
import MonitoringConsultationDeskReportsNumberCard from '@/components/cards/MonitoringConsultationDeskReportsNumberCard.vue'
import PositiveNumberByDiagnosedDateCard from '@/components/cards/PositiveNumberByDiagnosedDateCard.vue'
import PositiveRateCard from '@/components/cards/PositiveRateCard.vue'
import SelfDisclosuresCard from '@/components/cards/SelfDisclosuresCard.vue'
import TelephoneAdvisoryReportsNumberCard from '@/components/cards/TelephoneAdvisoryReportsNumberCard.vue'
import TestedNumberCard from '@/components/cards/TestedNumberCard.vue'
import UntrackedRateCard from '@/components/cards/UntrackedRateCard.vue'
import WeeklyMapCard from '@/components/cards/WeeklyMapCard.vue'
import WhatsNewCard from '@/components/cards/WhatsNewCard.vue'
import Data from '@/data/data.json'
import PositiveRate from '@/data/positive_rate.json'
import PositiveStatus from '@/data/positive_status.json'
import { getDayjsObject } from '@/utils/formatDate.ts'
import { getLinksLanguageAlternative } from '@/utils/i18nUtils'

export default {
  components: {
    WeeklyMapCard,
    Breadcrumb,
    WhatsNewCard,
    SelfDisclosuresCard,
    MonitoringConfirmedCasesNumberCard,
    // SevereCaseCard,
    MonitoringConsultationDeskReportsNumberCard,
    PositiveRateCard,
    UntrackedRateCard,
    ConfirmedCasesDetailsCard,
    ConfirmedCasesNumberCard,
    ConfirmedCasesAttributesCard,
    ConfirmedCasesByMunicipalitiesCard,
    TestedNumberCard,
    TelephoneAdvisoryReportsNumberCard,
    PositiveNumberByDiagnosedDateCard,
    HospitalizedNumberCard,
  },
  data() {
    let title, updatedAt, cardComponent, cardTitle
    switch (this.$route.params.card) {
      case 'weekly-map':
        cardComponent = 'weekly-map-card'
        cardTitle = this.$t('WeeklyMapCard.title')
        break
      case 'whats-new':
        cardComponent = 'whats-new-card'
        cardTitle = this.$t('WhatsNewCard.title')
        break
      case 'self-disclosures':
        cardComponent = 'self-disclosures-card'
        cardTitle = this.$t('SelfDisclosuresCard.title')
        break
      case 'details-of-confirmed-cases':
        cardComponent = 'confirmed-cases-details-card'
        cardTitle = this.$t('ConfirmedCasesDetailsCard.title')
        break
      case 'number-of-confirmed-cases':
        cardComponent = 'confirmed-cases-number-card'
        cardTitle = this.$t('ConfirmedCasesNumberCard.title')
        break
      case 'number-of-confirmed-cases-by-municipalities':
        cardComponent = 'confirmed-cases-by-municipalities-card'
        cardTitle = this.$t('ConfirmedCasesByMunicipalitiesCard.title')
        break
      case 'attributes-of-confirmed-cases':
        cardComponent = 'confirmed-cases-attributes-card'
        cardTitle = this.$t('ConfirmedCasesAttributesCard.title')
        break
      case 'number-of-tested':
        cardComponent = 'tested-number-card'
        cardTitle = this.$t('TestedNumberCard.title')
        break
      case 'number-of-reports-to-covid19-telephone-advisory-center':
        cardComponent = 'telephone-advisory-reports-number-card'
        cardTitle = this.$t('TelephoneAdvisoryReportsNumberCard.title')
        break
      case 'positive-number-by-diagnosed-date':
        cardComponent = 'positive-number-by-diagnosed-date-card'
        cardTitle = this.$t('確定日別による陽性者数の推移')
        break
      case 'positive-rate':
        cardComponent = 'positive-rate-card'
        cardTitle = this.$t('PositiveRateCard.a[0]')
        break
      case 'monitoring-number-of-confirmed-cases':
        cardComponent = 'monitoring-confirmed-cases-number-card'
        cardTitle = this.$t('MonitoringConfirmedCasesNumberCard.titles[0]')
        break
      case 'untracked-rate':
        cardComponent = 'untracked-rate-card'
        cardTitle = this.$t('UntrackedRateCard.titles[0]')
        break
      // case 'positive-status-severe-case':
      //   cardComponent = 'severe-case-card'
      //   break
      case 'number-of-hospitalized':
        cardComponent = 'hospitalized-number-card'
        cardTitle = this.$t('HospitalizedNumberCard.title')
        break
      case 'monitoring-number-of-reports-to-covid19-consultation-desk':
        cardComponent = 'monitoring-consultation-desk-reports-number-card'
        cardTitle = this.$t('MonitoringConsultationDeskReportsNumberCard.title')
        break
    }

    const breadCrumb = {
      items: [
        {
          text: this.$t('Common.ホーム'),
          disabled: false,
          to: this.localePath('/'),
        },
        {
          text: cardTitle,
          disabled: false,
          to: this.$route.path,
        },
      ],
    }

    return {
      cardComponent,
      title,
      updatedAt,
      breadCrumb,
    }
  },
  head() {
    const url = 'https://iwate.stopcovid19.jp'

    const timestamp = new Date().getTime()

    const ogpImage =
      this.$i18n.locale === 'ja'
        ? `${url}/ogp/${this.$route.params.card}.png?t=${timestamp}`
        : `${url}/ogp/${this.$i18n.locale}/${this.$route.params.card}.png?t=${timestamp}`

    const date = Data.patients_summary.data.slice(-1)[0].日付

    const description = `${this.$t('{date}', {
      date: this.$d(getDayjsObject(date).toDate(), 'date'),
    })}${this.$t('は陽性が')}${
      PositiveRate.data.slice(-1)[0].positive_count
    }${this.$t('件・検査が')}${
      (PositiveRate.data.slice(-1)[0].pcr_positive_count ?? 0) +
      (PositiveRate.data.slice(-1)[0].pcr_negative_count ?? 0) +
      (PositiveRate.data.slice(-1)[0].antigen_positive_count ?? 0) +
      (PositiveRate.data.slice(-1)[0].antigen_negative_count ?? 0)
    }${this.$t('件・現在の入院患者は')}${
      PositiveStatus.data.slice(-1)[0].hospitalized
    }${this.$t(
      '人です。陽性者の属性、検査の陽性率、病床数、市町村別陽性者数、相談件数などの各種データや過去の推移グラフはこちら。'
    )}`

    const defaultTitle = `${this.$t('Common.岩手県')} ${this.$t(
      'Common.新型コロナウイルス感染症'
    )}${this.$t('Common.対策サイト')}`

    return {
      titleTemplate: (title) => `${this.title || title} | ${defaultTitle}`,
      link: [
        ...getLinksLanguageAlternative(
          `cards/${this.$route.params.card}`,
          this.$i18n.locales,
          this.$i18n.defaultLocale
        ),
      ],
      meta: [
        {
          hid: 'og:url',
          property: 'og:url',
          content: `${url}${this.$route.path}/`,
        },
        {
          hid: 'og:title',
          property: 'og:title',
          template: () => defaultTitle,
          content: '',
        },
        {
          hid: 'description',
          name: 'description',
          template: () => `${description}`,
          content: '',
        },
        {
          hid: 'og:description',
          property: 'og:description',
          template: () => `${description}`,
          content: '',
        },
        {
          hid: 'og:image',
          property: 'og:image',
          content: ogpImage,
        },
        {
          hid: 'twitter:image',
          name: 'twitter:image',
          content: ogpImage,
        },
      ],
    }
  },
}
</script>

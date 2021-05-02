<template>
  <v-app class="app">
    <v-overlay :value="loading" color="#F8F9FA" opacity="1" z-index="9999">
      <div class="loader">
        <img src="/logo.svg" :alt="$t('Common.岩手県')" />
        <scale-loader color="#00A040" />
      </div>
    </v-overlay>
    <div v-if="hasNavigation" class="appContainer">
      <div class="naviContainer">
        <side-navigation
          :is-navi-open="isOpenNavigation"
          :class="{ open: isOpenNavigation }"
          @open-navigation="openNavigation"
          @close-navigation="closeNavigation"
        />
      </div>
      <main class="mainContainer" :class="{ open: isOpenNavigation }">
        <v-container class="px-4 py-8">
          <nuxt />
        </v-container>
      </main>
    </div>
    <div v-if="!loading && !hasNavigation" class="embed">
      <v-container>
        <nuxt />
      </v-container>
    </div>
    <no-script />
  </v-app>
</template>

<script lang="ts">
import dayjs from 'dayjs'
import Vue from 'vue'
import { LinkPropertyHref, MetaInfo } from 'vue-meta'
import ScaleLoader from 'vue-spinner/src/ScaleLoader.vue'

import NoScript from '@/components/NoScript.vue'
import SideNavigation from '@/components/SideNavigation.vue'
import Data from '@/data/data.json'
import PositiveRate from '@/data/positive_rate.json'
import PositiveStatus from '@/data/positive_status.json'
import {
  convertDateToJapaneseKanjiFormat,
  getDayjsObject,
} from '@/utils/formatDate'
import { getLinksLanguageAlternative } from '@/utils/i18nUtils'

type LocalData = {
  hasNavigation: boolean
  isOpenNavigation: boolean
  loading: boolean
}
export default Vue.extend({
  components: {
    ScaleLoader,
    SideNavigation,
    NoScript,
  },
  data(): LocalData {
    let hasNavigation = true
    let loading = true
    if (this.$route.query.embed === 'true') {
      hasNavigation = false
      loading = false
    } else if (this.$route.query.ogp === 'true') {
      hasNavigation = false
      loading = false
    }
    return {
      hasNavigation,
      loading,
      isOpenNavigation: false,
    }
  },
  head(): MetaInfo {
    const { htmlAttrs, meta } = this.$nuxtI18nSeo()

    const ogLocale =
      meta && meta.length > 0
        ? meta[0]
        : {
            hid: 'og:locale',
            name: 'og:locale',
            content: this.$i18n.locale,
          }

    let linksAlternate: LinkPropertyHref[] = []

    const basename = this.getRouteBaseName()
    // 404 エラーなどのときは this.getRouteBaseName() が null になるため除外
    if (basename) {
      linksAlternate = getLinksLanguageAlternative(
        basename,
        this.$i18n.locales,
        this.$i18n.defaultLocale
      )
    }

    const date = Data.patients_summary.data.slice(-1)[0].日付

    const descriptionToday = `${this.$t('{date}', {
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
    }${this.$t('人です。')}`

    const description = `${descriptionToday}${this.$t(
      '陽性者の属性、検査の陽性率、病床数、市町村別陽性者数、相談件数などの各種データや過去の推移グラフはこちら。'
    )}`

    const defaultTitle = `${this.$t('Common.岩手県')} ${this.$t(
      'Common.新型コロナウイルス感染症'
    )}${this.$t('Common.対策サイト')}`

    return {
      htmlAttrs,
      script: [
        {
          type: 'application/ld+json',
          json: {
            '@context': 'http://schema.org',
            '@type': 'SpecialAnnouncement',
            datePosted: dayjs(date).toISOString(),
            expires: dayjs(date).add(1, 'day').toISOString(),
            name: `岩手県の${this.$t('{date}', {
              date: convertDateToJapaneseKanjiFormat(date),
            })}の陽性件数・検査件数・入院患者数`,
            text: descriptionToday,
            category: 'https://www.wikidata.org/wiki/Q81068910',
            url: 'https://iwate.stopcovid19.jp/',
            newsUpdatesAndGuidelines: 'https://iwate.stopcovid19.jp/',
            inLanguage: 'ja',
            diseaseSpreadStatistics: 'https://iwate.stopcovid19.jp/',
            spatialCoverage: [
              {
                '@type': 'AdministrativeArea',
                name: 'Iwate',
                geo: {
                  '@type': 'GeoCircle',
                  name: 'Iwate, Japan',
                  geoMidpoint: {
                    '@type': 'GeoCoordinates',
                    latitude: '39.648460',
                    longitude: '141.250707',
                    addressCountry: 'JP',
                    address: 'Iwate, Japan',
                  },
                  geoRadius: '100000',
                },
              },
            ],
          },
        },
        {
          type: 'application/ld+json',
          json: {
            '@context': 'http://schema.org',
            '@type': 'BreadcrumbList',
            itemListElement: [
              {
                '@type': 'ListItem',
                position: 1,
                name: 'まとめTOP',
                item: 'https://iwate.stopcovid19.jp/',
              },
              {
                '@type': 'ListItem',
                position: 2,
                name: 'お知らせ',
                item: 'https://iwate.stopcovid19.jp/cards/whats-new/',
              },
              {
                '@type': 'ListItem',
                position: 2,
                name: '自主公表',
                item: 'https://iwate.stopcovid19.jp/cards/self-disclosures/',
              },
              {
                '@type': 'ListItem',
                position: 2,
                name: '陽性者の状況',
                item:
                  'https://iwate.stopcovid19.jp/cards/details-of-confirmed-cases/',
              },
              {
                '@type': 'ListItem',
                position: 2,
                name: '日別陽性者数',
                item:
                  'https://iwate.stopcovid19.jp/cards/number-of-confirmed-cases/',
              },
              {
                '@type': 'ListItem',
                position: 2,
                name: '陽性者数グラフ',
                item:
                  'https://iwate.stopcovid19.jp/cards/monitoring-number-of-confirmed-cases/',
              },
              {
                '@type': 'ListItem',
                position: 2,
                name: '検査の陽性率',
                item: 'https://iwate.stopcovid19.jp/cards/positive-rate/',
              },
              {
                '@type': 'ListItem',
                position: 2,
                name: '入院患者数',
                item:
                  'https://iwate.stopcovid19.jp/cards/number-of-hospitalized/',
              },
              {
                '@type': 'ListItem',
                position: 2,
                name: '陽性者の属性',
                item:
                  'https://iwate.stopcovid19.jp/cards/attributes-of-confirmed-cases/',
              },
            ],
          },
        },
      ],
      link: [
        {
          rel: 'canonical',
          href: `https://iwate.stopcovid19.jp${this.$route.path}`,
        },
        ...linksAlternate,
      ],
      // Disable prettier for readability purposes
      // eslint-disable-next-line prettier/prettier
      titleTemplate: `%s | ${this.$t('Common.岩手県')} ${this.$t('Common.新型コロナウイルス感染症')}${this.$t('Common.対策サイト')}`,
      meta: [
        {
          hid: 'author',
          name: 'author',
          content: `${this.$t('岩手のCOVID-19が気になる有志')}`,
        },
        {
          hid: 'description',
          name: 'description',
          content: description,
        },
        {
          hid: 'og:site_name',
          property: 'og:site_name',
          content: defaultTitle,
        },
        {
          hid: 'og:url',
          property: 'og:url',
          content: `https://iwate.stopcovid19.jp${this.$route.path}`,
        },
        ogLocale,
        {
          hid: 'og:title',
          property: 'og:title',
          content: defaultTitle,
        },
        {
          hid: 'og:description',
          property: 'og:description',
          content: description,
        },
        {
          hid: 'og:image',
          property: 'og:image',
          content: `${this.$t('ogp.og:image')}`,
        },
        {
          hid: 'apple-mobile-web-app-title',
          name: 'apple-mobile-web-app-title',
          content: defaultTitle,
        },
        {
          hid: 'twitter:image',
          name: 'twitter:image',
          content: `${this.$t('ogp.og:image')}`,
        },
        {
          hid: 'google-site-verification',
          name: 'google-site-verification',
          content: 'wy96JdzncNSSkhp1c0EjfVdCXy0LQAMup_BHI0Bhb_Q',
        },
      ],
    }
  },
  mounted() {
    this.loading = false
    this.getMatchMedia().addListener(this.closeNavigation)
  },
  beforeDestroy() {
    this.getMatchMedia().removeListener(this.closeNavigation)
  },
  methods: {
    openNavigation(): void {
      this.isOpenNavigation = true
    },
    closeNavigation(): void {
      this.isOpenNavigation = false
    },
    getMatchMedia(): MediaQueryList {
      return window.matchMedia('(min-width: 601px)')
    },
  },
})
</script>
<style lang="scss">
.app {
  max-width: 1440px;
  margin: 0 auto;
  background-color: inherit !important;
}
.v-application--wrap {
  width: 100%;
}
.embed {
  .container {
    padding: 0 !important;
  }
  .DataCard {
    padding: 0 !important;
  }
}
.appContainer {
  position: relative;
  @include largerThan($small) {
    display: grid;
    grid-template-columns: 240px 1fr;
    grid-template-rows: auto;
  }
  @include largerThan($huge) {
    grid-template-columns: 325px 1fr;
    grid-template-rows: auto;
  }
}
.naviContainer {
  background-color: $white;
}
@include lessThan($small) {
  .naviContainer {
    position: sticky;
    position: -webkit-sticky;
    top: 0;
    z-index: z-index-of(sp-navigation);
  }
}
@include largerThan($small) {
  .naviContainer {
    grid-column: 1/2;
    position: fixed;
    top: 0;
    overflow-y: auto;
    width: 240px;
    height: 100%;
    border-right: 1px solid $gray-4;
    border-left: 1px solid $gray-4;
    box-shadow: 0 0 2px rgba(0, 0, 0, 0.15);
    overscroll-behavior: contain;
  }
}
@include largerThan($huge) {
  .naviContainer {
    width: 325px;
  }
}
.open {
  height: 100vh;
  @include largerThan($small) {
    overflow-x: hidden;
    overflow-y: auto;
  }
}
.mainContainer {
  grid-column: 2/3;
  overflow: hidden;
  @include lessThan($small) {
    .container {
      padding-top: 16px;
    }
  }
}
.loader {
  height: 200px;
  width: 150px;
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translateY(-50%) translateX(-50%);
  img {
    display: block;
    margin: 0 auto 20px;
  }
}
</style>

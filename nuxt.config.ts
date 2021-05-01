import { NuxtConfig } from '@nuxt/types'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'

// eslint-disable-next-line no-restricted-imports
import i18n from './nuxt-i18n.config'
const environment = process.env.NODE_ENV || 'development'

const config: NuxtConfig = {
  target: 'static',
  components: true,
  /*
   ** Headers of the page
   */
  head: {
    htmlAttrs: {
      prefix: 'og: http://ogp.me/ns#',
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'og:type', property: 'og:type', content: 'website' },
      {
        hid: 'og:url',
        property: 'og:url',
        content: 'https://iwate.stopcovid19.jp',
      },
      {
        hid: 'twitter:card',
        name: 'twitter:card',
        content: 'summary_large_image',
      },
      {
        hid: 'fb:app_id',
        property: 'fb:app_id',
        content: '320122459207066',
      },
      {
        hid: 'note:card',
        property: 'note:card',
        content: 'summary_large_image',
      },
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      { rel: 'apple-touch-icon', href: '/apple-touch-icon-precomposed.png' },
    ],
    script: [
      {
        src:
          'https://polyfill.io/v3/polyfill.min.js?features=IntersectionObserver',
        defer: true,
      },
    ],
  },
  /*
   ** Customize the progress-bar color
   */
  loading: { color: '#fff' },
  /*
   ** Global CSS
   */
  css: ['@/assets/global.scss'],
  /*
   ** Plugins to load before mounting the App
   */
  plugins: [
    {
      src: '@/plugins/vue-chart.ts',
      ssr: true,
    },
  ],
  /*
   ** Nuxt.js dev-modules
   */
  buildModules: [
    '@nuxtjs/pwa',
    '@nuxtjs/stylelint-module',
    '@nuxtjs/vuetify',
    '@nuxt/typescript-build',
    '@nuxtjs/google-analytics',
    '@nuxtjs/gtm',
    'nuxt-purgecss',
  ],
  /*
   ** Nuxt.js modules
   */
  modules: [
    // Doc: https://github.com/nuxt-community/dotenv-module
    ['@nuxtjs/dotenv', { filename: `.env.${environment}` }],
    ['nuxt-i18n', i18n],
    'nuxt-svg-loader',
    ['vue-scrollto/nuxt', { duration: 1000, offset: -72 }],
    '@nuxtjs/sitemap',
  ],
  /*
   ** vuetify module configuration
   ** https://github.com/nuxt-community/vuetify-module
   */
  vuetify: {
    customVariables: ['@/assets/variables.scss'],
    optionsPath: './plugins/vuetify.options.ts',
    treeShake: true,
    defaultAssets: false,
  },
  googleAnalytics: {
    id: process.env.GOOGLE_ANALYTICS_ID, // .env.production などに設定してください。
  },
  gtm: {
    id: 'GTM-WQK97B9',
    pageTracking: true,
    enabled: true,
  },
  /*
   * nuxt-i18n による自動リダイレクトを停止したためコメントアウト
   * @todo 「Cookieがあるときのみ、その言語にリダイレクトする」を実装する場合は復活させる
   * 実装しない場合は以下の記述を完全に削除する
   */
  /* optionalCookies: [
    {
      name: 'i18n_redirected',
      label: 'i18n Redirection Cookie',
      description:
        'For automatically switching UI languages in accordance with locale preferences in the web browser configuration.',
      cookies: ['i18n_redirected']
    }
  ], */
  build: {
    postcss: {
      preset: {
        autoprefixer: {
          // Built-in since nuxt@2.14.5
          grid: 'autoplace',
        },
      },
    },
    extend(config) {
      // default externals option is undefined
      config.externals = [{ moment: 'moment' }]
    },
  },
  purgeCSS: {
    enabled: true,
    paths: [
      './node_modules/vuetify/dist/vuetify.js',
      './node_modules/vue-spinner/src/ScaleLoader.vue',
    ],
    whitelist: ['DataCard', 'GraphLegend'],
    whitelistPatterns: [/(col|row)/],

    // This is nuxt-purgecss 1.0.0 default settings
    // https://github.com/Developmint/nuxt-purgecss#defaults
    // This extractor purge <style module>
    // <style scoped> is not purged by default whitelistPatterns
    //
    // extractors: [
    //   {
    //     extractor: (content: string) => {
    //       const contentWithoutStyleBlocks = content.replace(
    //         /<style[^]+?<\/style>/gi,
    //         ''
    //       ) // Remove inline vue styles
    //       return contentWithoutStyleBlocks.match(/[\w-.:/]+(?<!:)/g) || []
    //     },
    //     extensions: ['html', 'vue', 'js'],
    //   },
    // ],
    //

    // so override extractors
    // https://github.com/Developmint/nuxt-purgecss#use-custom-extractors
    extractors: () => [
      {
        extractor(content: string): RegExpMatchArray | null {
          return content.match(/[A-z0-9-:\\/]+/g)
        },
        extensions: ['html', 'vue', 'js'],
      },
    ],
  },
  pwa: {
    meta: {
      theme_color: '#00a040',
      lang: 'ja',
    },
    manifest: {
      name: '岩手県 新型コロナウイルス感染症対策サイト 非公式',
      short_name: '岩手COVID19',
      lang: 'ja',
    },
    workbox: {
      enabled: false,
    },
  },
  generate: {
    fallback: true,
    routes() {
      const locales = ['en']
      const pages = [
        '/cards/weekly-map',
        '/cards/whats-new',
        '/cards/self-disclosures',
        '/cards/details-of-confirmed-cases',
        '/cards/number-of-confirmed-cases',
        '/cards/monitoring-number-of-confirmed-cases',
        '/cards/untracked-rate',
        '/cards/positive-rate',
        '/cards/number-of-hospitalized',
        '/cards/attributes-of-confirmed-cases',
        '/cards/number-of-confirmed-cases-by-municipalities',
        '/cards/number-of-tested',
        '/cards/monitoring-number-of-reports-to-covid19-consultation-desk',
        '/cards/number-of-reports-to-covid19-telephone-advisory-center',
      ]
      const localizedPages = locales
        .map((locale) => pages.map((page) => `/${locale}${page}`))
        .reduce((a, b) => [...a, ...b], [])
      return [...pages, ...localizedPages]
    },
  },
  // /*
  // ** hot read configuration for docker
  // */
  watchers: {
    webpack: {
      poll: true,
    },
  },
  sitemap: {
    hostname: 'https://iwate.stopcovid19.jp/',
    gzip: true,
    exclude: [
      '**/about',
      '**/contacts',
      '**/flow',
      '**/worker',
      '**/print/flow',
    ],
    routes() {
      dayjs.extend(utc)
      const now = dayjs().utc().format()
      return [
        {
          url: '/',
          changefreq: 'daily',
          priority: 1.0,
          lastmod: now,
        },
        {
          url: '/cards/weekly-map/',
          changefreq: 'daily',
          priority: 0.8,
          lastmod: now,
        },
        {
          url: '/cards/whats-new/',
          changefreq: 'daily',
          priority: 0.8,
          lastmod: now,
        },
        {
          url: '/cards/self-disclosures/',
          changefreq: 'daily',
          priority: 0.8,
          lastmod: now,
        },
        {
          url: '/cards/details-of-confirmed-cases/',
          changefreq: 'daily',
          priority: 0.8,
          lastmod: now,
        },
        {
          url: '/cards/number-of-confirmed-cases/',
          changefreq: 'daily',
          priority: 0.8,
          lastmod: now,
        },
        {
          url: '/cards/monitoring-number-of-confirmed-cases/',
          changefreq: 'daily',
          priority: 0.8,
          lastmod: now,
        },
        {
          url: '/cards/untracked-rate/',
          changefreq: 'daily',
          priority: 0.8,
          lastmod: now,
        },
        {
          url: '/cards/positive-rate/',
          changefreq: 'daily',
          priority: 0.8,
          lastmod: now,
        },
        {
          url: '/cards/number-of-hospitalized/',
          changefreq: 'daily',
          priority: 0.8,
          lastmod: now,
        },
        {
          url: '/cards/attributes-of-confirmed-cases/',
          changefreq: 'daily',
          priority: 0.8,
          lastmod: now,
        },
        {
          url: '/cards/number-of-confirmed-cases-by-municipalities/',
          changefreq: 'daily',
          priority: 0.8,
          lastmod: now,
        },
        {
          url: '/cards/number-of-tested/',
          changefreq: 'daily',
          priority: 0.8,
          lastmod: now,
        },
        {
          url:
            '/cards/monitoring-number-of-reports-to-covid19-consultation-desk/',
          changefreq: 'weekly',
          priority: 0.3,
          lastmod: now,
        },
        {
          url: '/cards/number-of-reports-to-covid19-telephone-advisory-center/',
          changefreq: 'weekly',
          priority: 0.3,
          lastmod: now,
        },
      ]
    },
  },
}

export default config

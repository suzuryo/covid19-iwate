import { NuxtConfig } from '@nuxt/types'
import dayjs from 'dayjs'
import utc from 'dayjs/plugin/utc'

// eslint-disable-next-line no-restricted-imports
import i18n from './nuxt-i18n.config'
const environment = process.env.NODE_ENV || 'development'
dayjs.extend(utc)
const now = dayjs().utc().format()

const pages = [
  '/cards/weekly-map/',
  '/cards/whats-new/',
  '/cards/self-disclosures/',
  '/cards/details-of-confirmed-cases/',
  '/cards/number-of-confirmed-cases/',
  '/cards/monitoring-number-of-confirmed-cases/',
  '/cards/monitoring-number-of-confirmed-cases-per-100k/',
  '/cards/effective-reproduction-number/',
  '/cards/untracked-rate/',
  '/cards/positive-rate/',
  '/cards/number-of-hospitalized/',
  '/cards/attributes-of-confirmed-cases/',
  '/cards/number-of-confirmed-cases-by-municipalities/',
  '/cards/number-of-tested/',
  '/cards/hospital-capacity/',
  '/cards/hotel-capacity/',
]

const config: NuxtConfig = {
  server: {
    host: '0.0.0.0',
  },
  target: 'static',
  components: false, // disable components auto import
  /*
   ** Headers of the page
   */
  head: {
    htmlAttrs: {
      prefix: 'og: http://ogp.me/ns#',
    },
    meta: [
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
        src: 'https://polyfill.io/v3/polyfill.min.js?features=IntersectionObserver',
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
    {
      src: '@/plugins/axe',
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
    '@nuxtjs/gtm',
    // 'nuxt-purgecss',
  ],
  /*
   ** Nuxt.js modules
   */
  modules: [
    // Doc: https://github.com/nuxt-community/dotenv-module
    ['@nuxtjs/dotenv', { filename: `.env.${environment}` }],
    ['nuxt-i18n', i18n],
    'nuxt-svg-loader',
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
    // analyze: true,
    babel: {
      presets({ envName }) {
        const envTargets = {
          client: { browsers: ['last 2 versions'], ie: 11 },
          server: { node: 'current' },
          modern: true,
        }
        return [
          [
            '@nuxt/babel-preset-app',
            {
              corejs: { version: '3.14' },
              targets: envTargets[envName],
            },
          ],
        ]
      },
    },
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
  // purgeCSS: {
  //   enabled: true,
  //   paths: [
  //     './node_modules/vuetify/dist/vuetify.js',
  //     './node_modules/vue-spinner/src/ScaleLoader.vue',
  //   ],
  //   whitelist: ['DataCard', 'GraphLegend'],
  //   whitelistPatterns: [/(col|row)/],
  //
  //   // This is nuxt-purgecss 1.0.0 default settings
  //   // https://github.com/Developmint/nuxt-purgecss#defaults
  //   // This extractor purge <style module>
  //   // <style scoped> is not purged by default whitelistPatterns
  //   //
  //   // extractors: [
  //   //   {
  //   //     extractor: (content: string) => {
  //   //       const contentWithoutStyleBlocks = content.replace(
  //   //         /<style[^]+?<\/style>/gi,
  //   //         ''
  //   //       ) // Remove inline vue styles
  //   //       return contentWithoutStyleBlocks.match(/[\w-.:/]+(?<!:)/g) || []
  //   //     },
  //   //     extensions: ['html', 'vue', 'js'],
  //   //   },
  //   // ],
  //   //
  //
  //   // so override extractors
  //   // https://github.com/Developmint/nuxt-purgecss#use-custom-extractors
  //   extractors: () => [
  //     {
  //       extractor(content: string): RegExpMatchArray | null {
  //         return content.match(/[A-z0-9-:\\/]+/g)
  //       },
  //       extensions: ['html', 'vue', 'js'],
  //     },
  //   ],
  // },
  pwa: {
    meta: {
      theme_color: '#00a040',
      lang: 'ja',
    },
    manifest: {
      name: '岩手県 新型コロナウイルス感染症対策サイト 非公式',
      short_name: '岩手COVID19',
    },
    workbox: {
      enabled: false,
    },
  },
  router: {
    trailingSlash: true,
  },
  generate: {
    fallback: true,
    routes() {
      const locales = ['en']
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
    trailingSlash: true,
    exclude: [
      // @nuxtjs/sitemapがpagesしかi18n対応していないので、自動生成される分をexcludeで全て外しておいて、
      // routes()で手動で管理することで多言語対応のhreflang付きのsitemapを生成するworkaround
      '/',
      '/en/',
      '**/about',
      '**/flow',
      '**/vaccine/',
      '**/worker',
      '**/print/flow',
    ],
    defaults: {
      changefreq: 'daily',
      priority: 1,
      lastmod: now,
    },
    routes() {
      return ['/', '/about/', '/flow/', '/vaccine/', '/worker/', ...pages].map(
        (page) => ({
          url: `${page}`,
          links: [
            { lang: 'ja', url: `${page}` },
            { lang: 'en', url: `/en${page}` },
          ],
        })
      )
    },
  },
}

export default config

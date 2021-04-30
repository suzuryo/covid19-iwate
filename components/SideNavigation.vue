<template>
  <div ref="Side" class="SideNavigation" tabindex="-1">
    <header class="SideNavigation-Header">
      <v-icon
        class="SideNavigation-OpenIcon"
        :aria-label="$t('SideNavigation.a[0]')"
        @click="$emit('open-navigation', $event)"
      >
        {{ mdiMenu }}
      </v-icon>
      <h1 class="SideNavigation-HeaderTitle">
        <app-link :to="localePath('/')" class="SideNavigation-HeaderLink">
          <img
            class="SideNavigation-HeaderLogo"
            src="/logo.svg"
            :alt="$t('Common.岩手県')"
            width="111"
            height="28"
          />
          <div class="SideNavigation-HeaderText">
            {{ $t('Common.新型コロナウイルス感染症') }}<br />
            {{ $t('Common.対策サイト') }}
          </div>
        </app-link>
      </h1>
    </header>

    <div
      v-if="isNaviOpen || $vuetify.breakpoint.smAndUp"
      :class="['SideNavigation-Body', { '-opened': isNaviOpen }]"
    >
      <v-icon
        class="SideNavigation-CloseIcon"
        :aria-label="$t('SideNavigation.a[1]')"
        @click="$emit('close-navigation', $event)"
      >
        {{ mdiClose }}
      </v-icon>

      <nav class="SideNavigation-Menu">
        <div class="SideNavigation-Language">
          <div v-if="$i18n.locales.length > 1" class="SideNavigation-Language">
            <label class="SideNavigation-LanguageLabel" for="LanguageSelector">
              {{ $t('Common.多言語対応選択メニュー') }}
            </label>
            <language-selector />
          </div>
        </div>
        <menu-list :items="items" @click="$emit('close-navigation', $event)" />
      </nav>

      <footer class="SideNavigation-Footer">
        <div class="SideNavigation-Social">
          <app-link
            to="https://line.me/R/ti/p/%40566kxdol"
            :show-icon="false"
            class="SideNavigation-SocialLink"
          >
            <picture>
              <source srcset="/line.webp" type="image/webp" />
              <img src="/line.png" alt="LINE" width="30" height="30" />
            </picture>
          </app-link>
          <app-link
            to="https://twitter.com/iwatevscovid19"
            :show-icon="false"
            class="SideNavigation-SocialLink"
          >
            <picture>
              <source srcset="/twitter.webp" type="image/webp" />
              <img src="/twitter.png" alt="Twitter" width="30" height="30" />
            </picture>
          </app-link>
          <app-link
            to="https://github.com/MeditationDuck/covid19"
            :show-icon="false"
            class="SideNavigation-SocialLink"
          >
            <picture>
              <source srcset="/github.webp" type="image/webp" />
              <img src="/github.png" alt="GitHub" width="30" height="30" />
            </picture>
          </app-link>
        </div>
        <i18n
          tag="small"
          path="このサイトの内容物は{creativeCommons}の下に提供されています。"
          class="SideNavigation-Copyright"
        >
          <template #creativeCommons>
            <app-link
              :to="$t('SideNavigation.a[2]')"
              :icon-size="12"
              class="SideNavigation-LicenseLink"
            >
              {{ $t('SideNavigation.a[3]') }}
            </app-link>
          </template>
        </i18n>
        <br />
        <small class="SideNavigation-Copyright">
          &copy; 2020 Meditation Duck
        </small>
      </footer>
    </div>
  </div>
</template>

<script lang="ts">
import {
  mdiAccountMultiple,
  mdiChartTimelineVariant,
  mdiClose,
  mdiDomain,
  mdiMenu,
  mdiNeedle,
} from '@mdi/js'
import Vue from 'vue'
import { TranslateResult } from 'vue-i18n'

import AppLink from '@/components/AppLink.vue'
import LanguageSelector from '@/components/LanguageSelector.vue'
import MenuList from '@/components/MenuList.vue'

type Item = {
  iconPath?: string
  svg?: string
  title: TranslateResult
  link: string | TranslateResult
  divider?: boolean
}

export default Vue.extend({
  components: {
    LanguageSelector,
    MenuList,
    AppLink,
  },
  props: {
    isNaviOpen: {
      type: Boolean,
      required: true,
    },
  },
  data() {
    return {
      mdiClose,
      mdiMenu,
      mdiNeedle,
    }
  },
  computed: {
    items(): Item[] {
      return [
        {
          iconPath: mdiChartTimelineVariant,
          title: this.$t('Common.岩手の最新感染動向'),
          link: this.localePath('/'),
        },
        {
          svg: 'CovidIcon',
          title: this.$t('SideNavigation.a[4]'),
          link: this.localePath('/flow'),
        },
        {
          iconPath: mdiNeedle,
          title: this.$t('SideNavigation.a[10]'),
          link:
            'https://www.pref.iwate.jp/kurashikankyou/iryou/covid19/1037252.html',
        },
        {
          iconPath: mdiAccountMultiple,
          title: this.$t('SideNavigation.a[5]'),
          link:
            'https://www.pref.iwate.jp/kurashikankyou/iryou/covid19/1028768.html',
        },
        {
          iconPath: mdiDomain,
          title: this.$t('SideNavigation.a[6]'),
          link: this.localePath('/worker'),
          divider: true,
        },
        {
          title: this.$t('SideNavigation.a[7]'),
          link: this.$t('SideNavigation.a[8]'),
        },
        {
          title: this.$t('SideNavigation.a[9]'),
          link:
            'https://www.pref.iwate.jp/kurashikankyou/iryou/kenkou/jouhou/1035134.html',
        },
        {
          title: this.$t('Common.当サイトについて'),
          link: this.localePath('/about'),
        },
      ]
    },
  },
  watch: {
    $route: 'handleChageRoute',
  },
  methods: {
    handleChageRoute() {
      // nuxt-link で遷移するとフォーカスが残り続けるので $route を監視して SideNavigation にフォーカスする
      return this.$nextTick().then(() => {
        const $Side = this.$refs.Side as HTMLEmbedElement | undefined
        if ($Side) {
          $Side.focus()
        }
      })
    },
  },
})
</script>

<style lang="scss" scoped>
.SideNavigation {
  position: relative;
  @include lessThan($small) {
    box-shadow: 0 0 2px rgba(0, 0, 0, 0.15);
  }
  &:focus {
    outline: 1px dotted $gray-3;
  }
}

.SideNavigation-Header {
  height: 64px;
  padding-left: 52px;
  @include largerThan($small) {
    height: auto;
    padding: 20px;
  }
  @include lessThan($small) {
    display: flex;
  }
  @include lessThan($tiny) {
    padding-left: 44px;
  }
}

.SideNavigation-OpenIcon {
  position: absolute;
  top: 0;
  left: 0;
  padding: 18px 8px 18px 16px;
  font-size: 28px;
  @include lessThan($tiny) {
    font-size: 24px;
    padding: 20px 10px;
  }
  @include largerThan($small) {
    display: none;
  }
}

.SideNavigation-CloseIcon {
  position: absolute;
  top: 0;
  left: 0;
  padding: 18px 8px 18px 16px;
  font-size: 28px;
  @include lessThan($tiny) {
    font-size: 24px;
    padding: 20px 10px;
  }
  @include largerThan($small) {
    display: none;
  }
}

.SideNavigation-HeaderTitle {
  width: 100%;
  color: #707070;
  @include font-size(13);
  @include largerThan($small) {
    margin: 0;
    margin-top: 10px;
  }
}

.SideNavigation-HeaderLink {
  display: flex;
  align-items: center;
  padding-right: 10px;
  @include lessThan($small) {
    height: 64px;
  }
  @include lessThan($tiny) {
    justify-content: space-between;
  }
  &:link,
  &:hover,
  &:focus,
  &:visited,
  &:active {
    color: inherit;
    text-decoration: none;
  }

  &:hover,
  &:focus {
    font-weight: bold;
  }

  &:focus {
    outline: dotted $gray-3 1px;
  }

  @include largerThan($small) {
    display: block;
    padding: 15px 0;
  }
}

.SideNavigation-HeaderLogo {
  @include lessThan($tiny) {
    width: 100px;
  }
}

.SideNavigation-HeaderText {
  margin: 10px 0 0 0;
  @include lessThan($small) {
    margin: 0 0 0 10px;
  }

  @include lessThan($tiny) {
    margin: 0;
  }
}

.SideNavigation-Body {
  padding: 0 20px 20px;
  @include lessThan($small) {
    display: none;
    padding: 0 36px 36px;
    &.-opened {
      position: fixed;
      top: 0;
      bottom: 0;
      left: 0;
      display: block !important;
      width: 100%;
      z-index: z-index-of(opened-side-navigation);
      background-color: $white;
      height: 100%;
      overflow: auto;
      -webkit-overflow-scrolling: touch;
    }
  }
}

.SideNavigation-Menu {
  @include lessThan($small) {
    padding-top: 50px;
  }
}

.SideNavigation-Footer {
  padding-top: 20px;
}

.SideNavigation-Social {
  display: flex;
}

.SideNavigation-SocialLink {
  border: 1px dotted transparent;
  border-radius: 30px;
  color: $gray-3;
  margin-bottom: 15px;

  &:link,
  &:hover,
  &:visited,
  &:active {
    color: inherit;
    text-decoration: none;
  }

  &:focus {
    color: inherit;
    text-decoration: none;
    border: 1px dotted $gray-3;
    outline: none;
  }

  & + & {
    margin-left: 10px;
  }

  img {
    width: 30px;
  }
}

.SideNavigation-Copyright {
  display: inline-block;
  color: $gray-1;
  line-height: 1.3;
  font-weight: bold;
  @include font-size(10);
}

.SideNavigation-LicenseLink {
  &:focus {
    outline: 1px dotted $gray-3;
  }
}
</style>

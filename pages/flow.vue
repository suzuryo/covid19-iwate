<template>
  <div>
    <div :class="$style.title">
      <covid-icon aria-hidden="true" />
      <page-header :class="$style.text">
        <template #pageHeader>
          {{ $t('SideNavigation.a[4]') }}
        </template>
      </page-header>
      <printer-button :wrapper-class="$style.printerButton" to="/print/flow" />
    </div>
    <div :class="$style.container">
      <h3 ref="upperTrigger" :class="$style.conHeading">
        {{ $t('新型コロナウイルス感染症にかかる相談窓口について') }}
      </h3>
      <div id="sy" :class="$style.section">
        <h4 :class="$style.sxnHeading">
          <fig-cond-sy :class="$style.fig" aria-hidden="true" />
          {{ $t('症状のある方') }}
        </h4>
        <div :class="[$style.box, $style.bgYellow]">
          <h5 :class="$style.boxHeading">
            {{
              $t(
                '地域の医療機関（かかりつけ医）に電話で相談・受診予約をしてください'
              )
            }}
          </h5>
          <p>
            {{
              $t(
                'かかりつけ医にて受診・検査をおこないます（診療・検査医療機関の場合）'
              )
            }}
          </p>
          <p>
            {{ $t('または、かかりつけ医の紹介先で受診・検査となります') }}
          </p>
        </div>
        <div :class="[$style.box, $style.bgYellow]">
          <h5 :class="$style.boxHeading">
            {{
              $t(
                '相談する医療機関に迷う場合や「かかりつけ医」がない場合「受診・相談センター」'
              )
            }}
          </h5>
          <dl :class="$style.contact">
            <div>
              <dt>
                {{ $t('24時間 全日（土日・祝日を含む）') }}
              </dt>
              <dd>
                <a :class="$style.tel" href="tel:019-651-3175">
                  <icon-phone :class="$style.icon" aria-hidden="true" />
                  019-651-3175</a
                >
              </dd>
            </div>
          </dl>
          <p :class="$style.notice">
            {{
              $t(
                '聴覚に障害のある方をはじめ電話でのご相談が難しい方に向けてファクス (019-626-0837) でも受付をしています。'
              )
            }}
          </p>
        </div>
      </div>
      <div id="anx" ref="lowerTrigger" :class="$style.section">
        <h4 :class="$style.sxnHeading">
          <fig-cond-anx :class="$style.fig" aria-hidden="true" />
          {{ $t('不安に思う方') }}
        </h4>
        <p :class="$style.sxnText">
          {{
            $t(
              '感染したかもしれないと不安に思う方、感染予防法を知りたい方などは、下記、新型コロナウイルス感染症相談窓口にご相談ください。'
            )
          }}
        </p>
        <div :class="[$style.box, $style.bgGray]">
          <h5 :class="$style.boxHeading">
            <!-- TODO: 対応言語を確認 -->
            {{ $t('新型コロナウイルス感染症相談窓口') }}
          </h5>
          <dl :class="$style.contact">
            <dt>{{ $t('9時～21時（土日祝含む）') }}</dt>
            <dd>
              <a :class="$style.tel" href="tel:019-629-6085">
                <icon-phone :class="$style.icon" aria-hidden="true" />
                019-629-6085</a
              >
            </dd>
          </dl>
          <p :class="$style.notice">
            {{
              $t(
                '聴覚に障害のある方をはじめ電話でのご相談が難しい方に向けてファクス (019-626-0837) でも受付をしています。'
              )
            }}
          </p>
        </div>
      </div>
    </div>
    <div v-show="!['ja'].includes($i18n.locale)">
      <div :class="$style.detail">
        <app-link
          to="https://www.pref.iwate.jp/kyouikubunka/kokusai/1006971/1027622/1027623.html"
          :icon-size="20"
          :icon-class="$style.icon"
          :class="$style.detailButton"
        >
          See details (Iwate COVID-19 related information) [EN]
        </app-link>
      </div>
    </div>
    <div :class="$style.detail">
      <app-link
        to="https://www.pref.iwate.jp/kurashikankyou/iryou/covid19/index.html#callcenter"
        :icon-size="20"
        :icon-class="$style.icon"
        :class="$style.detailButton"
        >{{ $t('詳細を見る（岩手県新型コロナウイルス感染症関連情報）') }}
      </app-link>
    </div>
  </div>
</template>

<script lang="ts">
import { mdiOpenInNew } from '@mdi/js'
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'
import { TranslateResult } from 'vue-i18n'

import AppLink from '@/components/AppLink.vue'
import PageHeader from '@/components/PageHeader.vue'
import PrinterButton from '@/components/PrinterButton.vue'
import CovidIcon from '@/static/covid.svg'
import FigCondAnx from '@/static/flow/cond_anx.svg'
import FigCondSy from '@/static/flow/cond_sy.svg'
import IconPhone from '@/static/flow/phone.svg'

type Data = {}
type Methods = {}
type Computed = {}
type Props = {}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  Data,
  Methods,
  Computed,
  Props
> = {
  name: 'Flow',
  components: {
    CovidIcon,
    PrinterButton,
    PageHeader,
    AppLink,
    FigCondSy,
    FigCondAnx,
    IconPhone,
  },
  data() {
    return {
      mdiOpenInNew,
    }
  },
  head(): any {
    const title: TranslateResult = this.$t('SideNavigation.a[4]')
    return {
      title,
    }
  },
}

export default options
</script>

<style lang="scss" module>
/* stylelint-disable no-descending-specificity */

$fzSmall: 14;
$fzRegular: 16;
$fzMedium: 18;
$fzLarge: 20;
$fzHuge: 22;
$fzHeading: 24;
$fzHeadingL: 26;

$padding: 20;
$margin: 20;

.title {
  display: flex;
  align-items: center;
  margin-bottom: $margin * 1px;
  > svg {
    width: 30px;
    height: 30px;
    > path:not(:first-of-type) {
      fill: $gray-2;
    }
  }
  .text {
    margin-left: 8px;
  }
  .printerButton {
    margin: 0 0 0 auto;
  }
}
.container {
  background-color: $white;
  box-shadow: $shadow;
  border: 0.5px solid $gray-4 !important;
  border-radius: 4px;
  padding: $padding * 1px;
  line-height: 1.35;
  color: $gray-2;
  @include font-size($fzRegular);

  > .conHeading {
    @include font-size($fzHeading);
  }
  ul {
    padding-left: 0; // override Vuetify style
  }
  p {
    margin-bottom: 0; // override Vuetify style
  }
}
.section {
  margin-top: $margin * 1.5px;
  padding: $padding * 1px;
  border: 3px solid $gray-3;
  border-radius: 10px;
  background-color: $white;
  &.yellow {
    border-width: 4px;
    border-color: $emergency;
  }
  > * {
    line-height: 1.5;
    &:not(.box):not(.boxes):not(:first-child) {
      margin-top: $margin * 1px;
    }
  }
  > .sxnHeading {
    text-align: center;
    font-weight: bold;
    > svg.fig {
      margin-top: 1px;
      max-width: 80px;
      max-height: 80px;
      vertical-align: middle;
    }
    @include font-size($fzHeadingL);
  }
  > .sxnText {
    margin-top: 20px;
    text-align: center;
    font-weight: bold;
    @include font-size($fzMedium);
  }
  > .hr {
    margin-top: $margin * 1px;
    padding-top: $margin * 1.5px;
    border-top: 1px solid $gray-2;
  }
}
.box {
  margin-top: $margin * 1px;
  display: flex;
  flex-direction: column;
  align-items: stretch;
  justify-content: center;
  border-radius: 4px;
  padding: $padding * 1px;
  text-align: center;
  line-height: 1.65;
  &.bgGray {
    background-color: $gray-2;
    color: $white;
    .icon path {
      fill: $white; // 内包するアイコンの色を変更
    }
  }
  &.bgYellow {
    background-color: $emergency;
  }
  > .boxHeading {
    font-weight: bold;
    @include font-size($fzLarge);
  }
  > .grow {
    flex: 1 0 auto;
  }
  > * {
    max-width: 100%;
  }
  > *:not(:first-child) {
    margin-top: $margin * 0.75px;
  }
  > .notice {
    width: 100%;
    padding: $margin * 1px;
    border-radius: 4px;
    background-color: $white;
    color: #a00000;
    text-align: center;
    font-weight: bold;
    line-height: 1.35;
    @include font-size($fzSmall);
  }
  > .contact {
    > div {
      display: flex;
      width: 100%;
      justify-content: center;
      align-items: flex-end;
      flex-wrap: wrap;
      > dt {
        margin-right: 0.5em;
      }
      > dd {
        text-align: left;
      }
    }
    > *:not(:first-child) {
      margin-top: $margin * 1px;
    }
  }
  li {
    list-style-type: none;
  }
  a {
    color: inherit;
    text-decoration: none;
    &:not(.tel) {
      > i {
        vertical-align: baseline;
      }
      &:hover {
        text-decoration: underline;
      }
    }
  }
}
.container .box a {
  color: inherit; // for IE11
}
.tel {
  font-weight: bold;
  vertical-align: baseline;
  white-space: nowrap;
  line-height: 1px * $fzHuge * 1.35;
  padding: 0 0.25em;
  @include font-size($fzHuge);

  > svg {
    vertical-align: baseline;
    max-width: 0.7em;
    max-height: 0.7em; // for IE11
    width: 100%;
  }

  &:visited,
  &:hover,
  &:active,
  &:focus {
    outline: 1px dotted $white;
  }
}
.detail {
  text-align: center;
  .detailButton {
    @include button-text('md');
    @include font-size(20);

    margin: ($margin * 1.5px) auto 0;
    font-weight: bold;
    text-decoration: none;
    color: $green-1 !important;
    &:hover {
      color: $white !important;
    }
    > .icon {
      margin-left: 2px;
      color: $green-1 !important;
    }
  }
}

// 600
@function px2vw($px, $vw: 600) {
  @return $px / $vw * 100vw;
}
@include lessThan($small) {
  .title {
    margin-bottom: px2vw($margin);
  }
  .container {
    padding: px2vw($padding);
    font-size: px2vw($fzRegular);
    > .conHeading {
      font-size: px2vw($fzHeading);
    }
  }
  .section {
    //margin-top: px2vw($margin * 1.5);
    margin-top: 20px; // フローティングの都合で固定
    padding: px2vw($padding);
    border-width: px2vw(3);
    border-radius: px2vw(10);
    &.yellow {
      border-width: px2vw(3);
    }
    > * {
      &:not(.box):not(.boxes):not(:first-child) {
        margin-top: px2vw($margin);
      }
    }
    > .sxnHeading {
      font-size: px2vw($fzHeadingL);
      > svg.fig {
        margin-top: 1px;
        max-width: 80px;
        max-height: 80px;
      }
    }
    > .sxnText {
      font-size: px2vw($fzMedium);
    }
    > .hr {
      margin-top: px2vw($margin);
      padding-top: px2vw($margin * 1.5);
    }
  }
  .box {
    margin-top: px2vw($margin);
    padding: px2vw($padding);
    border-radius: px2vw(4);
    &.border {
      border-width: px2vw(2);
    }
    > .boxHeading {
      font-size: px2vw($fzLarge);
    }
    > *:not(:first-child) {
      margin-top: px2vw($margin * 0.75);
    }
    > .notice {
      padding: px2vw($margin);
      border-radius: px2vw(4);
      font-size: px2vw($fzSmall);
    }
    > .contact {
      > *:not(:first-child) {
        margin-top: px2vw($margin);
      }
    }
  }
  .tel {
    font-size: px2vw($fzHuge);
  }
  .detail {
    .button {
      padding: px2vw(24) px2vw(36);
      margin: px2vw($margin * 1.5) auto 0;
      font-size: px2vw(20);
    }
  }
}
</style>

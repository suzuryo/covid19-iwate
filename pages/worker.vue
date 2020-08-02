<template>
  <div class="Worker">
    <page-header class="mb-3">
      {{ $t('企業の皆様・はたらく皆様へ') }}
    </page-header>
    <static-card>
      <h3>
        <external-link
          url="https://www.pref.iwate.jp/kurashikankyou/iryou/covid19/1028772.html"
          :icon-size="24"
          >{{ $t('事業者の皆様へのお知らせ') }}
        </external-link>
      </h3>
      <p>
        {{
          $t(
            '岩手県及び国の新型コロナウイルス感染症に関する支援策の情報をまとめています。'
          )
        }}
      </p>
    </static-card>
    <static-card>
      <h3>
        <external-link
          url="https://www.pref.iwate.jp/kurashikankyou/iryou/covid19/category_guideline.html"
          :icon-size="24"
          >{{ $t('業種ごとの感染拡大予防ガイドライン') }}
        </external-link>
      </h3>
      <p>
        {{
          $t(
            '新型コロナウイルス感染拡大防止のため、業種ごとに関係団体の情報を参考としてください。'
          )
        }}
      </p>
    </static-card>
    <static-card>
      <h3>
        <external-link
          url="https://smooth-biz.metro.tokyo.lg.jp/"
          :icon-size="24"
          >{{
            $t('新しいワークスタイルや企業活動の東京モデル「スムーズビズ」')
          }}
        </external-link>
      </h3>
      <p>
        {{
          $t(
            'テレワーク・時差出勤などスムーズビズの取組は、新型コロナウイルス感染症の対策としても効果的です。感染症対策として、東京2020大会時の交通混雑緩和に向けた取組の前倒しをお願いします。'
          )
        }}
      </p>
    </static-card>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { MetaInfo } from 'vue-meta'
import StaticCard from '@/components/StaticCard.vue'
import PageHeader from '@/components/PageHeader.vue'
import ExternalLink from '@/components/ExternalLink.vue'

export default Vue.extend({
  components: {
    PageHeader,
    StaticCard,
    ExternalLink,
  },
  head(): MetaInfo {
    return {
      title: this.$t('企業の皆様・はたらく皆様へ') as string,
    }
  },
})
</script>

<template>
  <div class="About">
    <page-header class="mb-3">
      <template #pageHeader>
        {{ $t('Common.当サイトについて') }}
      </template>
    </page-header>
    <static-card>
      <p v-for="(item, idx) in $t('About.a')" :key="idx">
        {{ item }}
      </p>
    </static-card>
    <static-card>
      <h3>{{ $t('About.b[0]') }}</h3>
      <p>{{ $t('About.b[1]') }}</p>
      <ul>
        <li v-for="(item, idx) in $t('About.b[2]')" :key="idx">{{ item }}</li>
      </ul>
      <p class="StaticCard-Note">
        <span>*</span>
        <span>{{ $t('About.b[3]') }}</span>
      </p>
    </static-card>
    <static-card>
      <h3>{{ $t('About.c[0]') }}</h3>
      <p>{{ $t('About.c[1]') }}</p>
    </static-card>
    <static-card>
      <h3>{{ $t('About.d[0]') }}</h3>
      <p v-for="(item, idx) in $t('About.d[1]')" :key="idx">
        {{ item }}
      </p>
    </static-card>
    <static-card>
      <h3>{{ $t('About.e[0]') }}</h3>
      <p v-for="(item, idx) in $t('About.e[1]')" :key="idx">
        {{ item }}
      </p>
    </static-card>
    <static-card>
      <h3>{{ $t('About.f[0]') }}</h3>
      <p v-for="(item, idx) in $t('About.f[1]')" :key="idx">
        {{ item }}
      </p>
      <ul>
        <li v-for="(item, idx) in $t('About.f[2]')" :key="idx">
          <app-link :to="item[1]" :icon-size="16">
            {{ item[0] }}
          </app-link>
        </li>
      </ul>
      <i18n tag="p" path="GA{addon}">
        <template #addon>
          <app-link :to="$t('About.f[3][0]')" :icon-size="16">
            {{ $t('About.f[3][1]') }}
          </app-link>
        </template>
      </i18n>
    </static-card>
    <static-card>
      <h3>{{ $t('About.g[0]') }}</h3>
      <p v-for="(item, idx) in $t('About.g[1]')" :key="idx">
        {{ item }}
      </p>
    </static-card>
    <static-card>
      <h3>{{ $t('About.h[0]') }}</h3>
      <p>
        {{ $t('About.h[1]') }}
        <i18n path="GH{githubRepo}">
          <template #githubRepo>
            <app-link
              to="https://github.com/MeditationDuck/covid19"
              :icon-size="16"
            >
              {{ $t('About.h[2]') }}
            </app-link>
          </template>
        </i18n>
      </p>
    </static-card>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { MetaInfo } from 'vue-meta'
import PageHeader from '@/components/PageHeader.vue'
import StaticCard from '@/components/StaticCard.vue'
import AppLink from '@/components/AppLink.vue'

export default Vue.extend({
  components: {
    PageHeader,
    StaticCard,
    AppLink,
  },
  head(): MetaInfo {
    return {
      title: this.$t('Common.当サイトについて') as string,
    }
  },
})
</script>

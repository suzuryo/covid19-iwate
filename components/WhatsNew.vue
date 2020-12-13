<template>
  <div class="WhatsNew">
    <div class="WhatsNew-heading">
      <h3 class="WhatsNew-title">
        <v-icon size="24" class="WhatsNew-title-icon">
          {{ mdiInformation }}
        </v-icon>
        {{ $t('最新のお知らせ') }}
      </h3>
    </div>
    <ul class="WhatsNew-list">
      <li v-for="(item, i) in items" :key="i" class="WhatsNew-list-item">
        <a
          class="WhatsNew-list-item-anchor"
          :href="item.url"
          target="_blank"
          rel="noopener noreferrer"
        >
          <time
            class="WhatsNew-list-item-anchor-time px-2"
            :datetime="formattedDate(item.date)"
          >
            {{ formattedDateForDisplay(item.date) }}
          </time>
          <span class="WhatsNew-list-item-anchor-link">
            {{ item.text }}
            <v-icon
              v-if="!isInternalLink(item.url)"
              class="WhatsNew-item-ExternalLinkIcon"
              size="12"
            >
              {{ mdiOpenInNew }}
            </v-icon>
          </span>
        </a>
      </li>
    </ul>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import { mdiInformation, mdiOpenInNew } from '@mdi/js'
import { convertDateToISO8601Format } from '@/utils/formatDate'

export default Vue.extend({
  props: {
    items: {
      type: Array,
      required: true,
    },
  },
  data() {
    return {
      mdiInformation,
      mdiOpenInNew,
    }
  },
  methods: {
    isInternalLink(path: string): boolean {
      return !/^https?:\/\//.test(path)
    },
    formattedDate(dateString: string) {
      return Date.parse(dateString)
        ? convertDateToISO8601Format(dateString)
        : ''
    },
    formattedDateForDisplay(dateString: string) {
      return Date.parse(dateString) ? this.$d(new Date(dateString), 'date') : ''
    },
  },
})
</script>

<style lang="scss">
.WhatsNew {
  @include card-container();

  padding: 10px;
  margin-bottom: 20px;

  .WhatsNew-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    margin-bottom: 12px;

    .WhatsNew-title {
      display: flex;
      align-items: center;
      color: $gray-2;
      @include card-h2();
      &-icon {
        margin: 3px;
      }
    }
  }

  .WhatsNew-list {
    padding-left: 0;
    list-style-type: none;

    &-item {
      &-anchor {
        display: flex;
        text-decoration: none;
        margin: 5px;
        @include font-size(14);

        @include lessThan($medium) {
          flex-wrap: wrap;
        }

        &-time {
          flex: 0 0 140px;
          margin-bottom: 0.8rem;

          @include lessThan($medium) {
            flex: 0 0 100%;
            font-weight: bold;
          }

          color: $gray-1;
        }

        &-link {
          flex: 0 1 auto;
          padding-left: 1rem;
          text-indent: -2rem;
          margin-bottom: 0.8rem;

          @include text-link();

          @include lessThan($medium) {
            padding-left: 3rem;
            text-indent: -2.2rem;
            margin-bottom: 1rem;
          }
        }

        &-ExternalLinkIcon {
          margin-left: 2px;
          color: $gray-3 !important;
        }
      }
    }
  }
}
</style>

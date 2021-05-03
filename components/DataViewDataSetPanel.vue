<template>
  <div class="DataView-DataSet">
    <h3 class="DataView-DataSet-title">
      <app-link
        :to="localePath(cardPath)"
        class="DataView-DataSet-title-HeaderLink"
      >
        {{ title }}
      </app-link>
    </h3>
    <div class="DataView-DataSet-DataInfo">
      <span v-if="lText !== ''" class="DataView-DataSet-DataInfo-summary">
        <span class="lTextBefore">
          {{ lTextBefore }}
        </span>
        <strong>
          {{ lText }}
        </strong>
        <small class="DataView-DataSet-DataInfo-summary-unit">
          {{ unit }}
        </small>
      </span>
      <br v-if="lText !== ''" />
      <small v-if="sText !== ''" class="DataView-DataSet-DataInfo-date">
        {{ sText }}
      </small>
      <div
        v-if="selfDisclosureForm"
        class="DataView-DataSet-DataInfo-SelfDisclosureForm"
      >
        <app-link to="https://forms.gle/JHB4HJ2c4NnPcmy69">
          情報提供フォーム
        </app-link>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'

import AppLink from '@/components/AppLink.vue'

export default Vue.extend({
  components: {
    AppLink,
  },
  props: {
    title: {
      type: String,
      required: true,
      default: '',
    },
    lTextBefore: {
      type: String,
      required: false,
      default: '',
    },
    lText: {
      type: String,
      required: false,
      default: '',
    },
    sText: {
      type: String,
      required: false,
      default: '',
    },
    unit: {
      type: String,
      required: false,
      default: '',
    },
    cardPath: {
      type: String,
      required: true,
    },
    selfDisclosureForm: {
      type: Boolean,
      required: false,
      default: false,
    },
  },
})
</script>

<style lang="scss">
.DataView {
  &-DataSet {
    display: flex;
    width: 100%;
    margin-bottom: 10px;

    &-title {
      font-size: 2rem;
      font-weight: normal;
      flex: 1 1 auto;
      &-HeaderLink {
        text-decoration: none;
        color: $gray-2 !important;
        &:hover {
          color: $green-1 !important;
        }
      }
    }

    &-DataInfo {
      text-align: right;

      &-summary {
        flex: 0 1 auto;
        display: inline-block;
        color: $gray-2;
        white-space: nowrap;
        font-style: normal;
        line-height: 30px;
        @include font-size(30);

        .lTextBefore {
          margin-right: 0.5rem;
          @include font-size(15);
        }

        strong {
          font-weight: 600;
        }

        &-unit {
          width: 100%;
          @include font-size(18);
        }
      }

      &-date {
        display: inline-block;
        width: 100%;
        color: $gray-3;
        line-height: initial;
        @include font-size(12);
      }

      &-SelfDisclosureForm {
        > a {
          height: 3rem;
          line-height: 3rem;
          display: inline-block;
          @include font-size(11);
        }
      }
    }
  }
}
</style>

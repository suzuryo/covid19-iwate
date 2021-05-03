<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <template #button>
      <span />
    </template>
    <v-data-table
      :ref="'displayedTable'"
      :headers="chartData.headers"
      :items="chartData.datasets"
      fixed-header
      :mobile-breakpoint="0"
      :custom-sort="customSort"
      :footer-props="{
        'items-per-page-options': [15, 30, 50, 100, 200, 300, -1],
        'items-per-page-text': $t('DataView_Footer[0]'),
      }"
      class="cardTable"
    >
      <template #body="{ items }">
        <tbody>
          <tr v-for="item in items" :key="item.text">
            <th class="text-start" scope="row">
              <template v-if="item['通番URL']">
                <app-link :to="item['通番URL']" :show-icon="false">
                  {{ item['通番'] }}
                </app-link>
              </template>
              <template v-else>
                {{ item['通番'] }}
              </template>
            </th>
            <td class="text-start">
              {{ positiveConfirmedDate(item['確定日']) }}
            </td>
            <td class="text-start">{{ item['発症日'] }}</td>
            <td class="text-start">{{ item['居住地'] }}</td>
            <td class="text-start">{{ item['年代'] }}</td>
            <td class="text-start">{{ item['接触歴'] }}</td>
            <td class="text-start">
              <template v-if="item['会見URL']">
                <app-link :to="item['会見URL']" :show-icon="false">
                  📺
                </app-link>
              </template>
            </td>
          </tr>
        </tbody>
      </template>
      <template slot="footer.page-text" slot-scope="props">
        {{
          $t('DataView_Footer[1]', {
            itemsLength: props.itemsLength,
            pageStart: props.pageStart,
            pageStop: props.pageStop,
          })
        }}
      </template>
    </v-data-table>
    <template #notes>
      <notes-expansion-panel
        class="DataView-ExpansionPanel"
        :expansion-panel-text="$t('Common.注')"
      >
        <template #notes>
          <slot name="notes" />
        </template>
      </notes-expansion-panel>
    </template>
    <template #dataSetPanel>
      <data-view-data-set-panel
        :title="title"
        :l-text="info.lText"
        :s-text="info.sText"
        :unit="info.unit"
        :card-path="`/cards/${titleId}`"
      />
    </template>
  </data-view>
</template>

<script lang="ts">
import Vue from 'vue'

import AppLink from '@/components/AppLink.vue'
import DataView from '@/components/DataView.vue'
import DataViewDataSetPanel from '@/components/DataViewDataSetPanel.vue'
import NotesExpansionPanel from '@/components/NotesExpansionPanel.vue'
import { getDayjsObject } from '@/utils/formatDate'

export default Vue.extend({
  components: { DataView, DataViewDataSetPanel, AppLink, NotesExpansionPanel },
  props: {
    title: {
      type: String,
      default: '',
    },
    titleId: {
      type: String,
      default: '',
    },
    chartData: {
      type: Object,
      default: () => {},
    },
    date: {
      type: String,
      default: '',
    },
    info: {
      type: Object,
      default: () => {},
    },
    customSort: {
      type: Function,
      default(items: Object[], index: string[], isDesc: boolean[]) {
        items.sort((a: any, b: any) => {
          let comparison = 0
          if (String(a[index[0]]) < String(b[index[0]])) {
            comparison = -1
          } else if (String(b[index[0]]) < String(a[index[0]])) {
            comparison = 1
          }
          // a と b が等しい場合は上記のif文を両方とも通過するので 0 のままとなる

          // 降順指定の場合は符号を反転
          if (comparison !== 0) {
            comparison = isDesc[0] ? comparison * -1 : comparison
          }
          return comparison
        })
        return items
      },
    },
  },
  mounted() {
    const vTables = this.$refs.displayedTable as Vue
    const vTableElement = vTables.$el
    const tables = vTableElement.querySelectorAll('table')
    // NodeListをIE11でforEachするためのワークアラウンド
    const nodes = Array.prototype.slice.call(tables, 0)
    nodes.forEach((table: HTMLElement) => {
      table.setAttribute('tabindex', '0')
    })
  },
  methods: {
    positiveConfirmedDate(day: string) {
      return this.$d(getDayjsObject(day).toDate(), 'dateWithoutYear')
    },
  },
})
</script>

<style lang="scss">
.cardTable {
  &.v-data-table {
    th {
      padding: 8px 10px !important;
      height: auto !important;
      border-bottom: 1px solid $gray-4 !important;
      color: $gray-2 !important;
      @include font-size(12, true);

      &.text-center {
        text-align: center;
      }
    }

    tbody {
      tr {
        color: $gray-1;
        th {
          font-weight: normal;
        }
        td {
          padding: 8px 10px !important;
          height: auto !important;
          @include font-size(12, true);

          &.text-center {
            text-align: center;
          }
        }

        &:nth-child(odd) {
          th,
          td {
            background: rgba($gray-4, 0.3);
          }
        }
      }
    }
    .v-select {
      margin-left: 10px;
    }
    &:focus {
      outline: dotted $gray-3 1px;
    }
  }
  .v-data-table__wrapper {
    box-shadow: 0 -20px 12px -12px #0003 inset;
  }
  .v-data-footer {
    @include font-size(12);
    &__pagination {
      margin-left: 0;
      margin-right: 5px;
    }
  }
  .v-data-footer__select .v-select__selections .v-select__selection--comma {
    font-size: 1.2rem;
  }
}
.v-menu__content {
  width: 60px;
  .v-list-item {
    padding: 0 8px;
  }
}
.v-list-item__title {
  font-size: 1.5rem;
}
</style>

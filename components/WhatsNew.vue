<template>
  <data-view :title="title" :title-id="titleId" :date="date">
    <div class="WhatsNew-Content">
      <v-data-table
        :ref="'displayedTable'"
        :items="items"
        :height="350"
        :items-per-page="200"
        :mobile-breakpoint="0"
        hide-default-header
        hide-default-footer
        class="cardTable"
      >
        <template #body="{ items }">
          <tbody>
            <tr v-for="(item, i) in items" :key="i">
              <td class="text-start">
                <template v-if="item.url">
                  <app-link :to="item.url" :show-icon="false">
                    {{ item.icon }}
                    {{ item.text }}
                  </app-link>
                </template>
                <template v-else>
                  {{ item.text }}
                </template>
              </td>
              <td class="text-end text-no-wrap">
                <span>{{ item.date }}</span>
              </td>
            </tr>
          </tbody>
        </template>
      </v-data-table>
    </div>
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
        :card-path="`/cards/${titleId}`"
      />
    </template>
    <slot name="self_disclosure_form" />
  </data-view>
</template>

<script lang="ts">
import Vue from 'vue'
import { ThisTypedComponentOptionsWithRecordProps } from 'vue/types/options'

import AppLink from '@/components/AppLink.vue'
import DataView from '@/components/DataView.vue'
import DataViewDataSetPanel from '@/components/DataViewDataSetPanel.vue'
import DataViewExpansionPanel from '@/components/DataViewExpansionPanel.vue'
import NotesExpansionPanel from '@/components/NotesExpansionPanel.vue'

type Data = {}
type Methods = {}
type Computed = {}
type Props = {
  title: string
  titleId: string
  date: string
  items: object
}

const options: ThisTypedComponentOptionsWithRecordProps<
  Vue,
  Data,
  Methods,
  Computed,
  Props
> = {
  components: {
    AppLink,
    DataView,
    DataViewDataSetPanel,
    DataViewExpansionPanel,
    NotesExpansionPanel,
  },
  props: {
    title: {
      type: String,
      default: '',
    },
    titleId: {
      type: String,
      required: false,
      default: '',
    },
    date: {
      type: String,
      required: true,
      default: '',
    },
    items: {
      type: Array,
      required: true,
      default: () => {},
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
}

export default Vue.extend(options)
</script>

<style lang="scss">
.WhatsNew {
  &-Content {
    .cardTable {
      table {
        tbody {
          tr {
            td {
              padding: 10px !important;
              @include font-size(12);
            }
          }
        }
      }
    }
  }
}
</style>

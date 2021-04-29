<template>
  <v-col id="HospitalizedNumberCard" cols="12" :md="md" class="DataCard">
    <client-only>
      <hospitalized-time-stacked-bar-chart
        :title="$t('HospitalizedNumberCard.title')"
        :title-id="'number-of-hospitalized'"
        :chart-id="'time-stacked-bar-chart-hospitalized'"
        :chart-data="hospitalizedGraph"
        :date="PositiveStatus.date"
        :items="hospitalizedItems"
        :labels="hospitalizedLabels"
        :unit="$t('Common.人')"
        :data-labels="hospitalizedDataLabels"
        :table-labels="hospitalizedTableLabels"
      >
        <template #notes>
          <table :class="$style.beds">
            <caption>
              {{
                $t('岩手県の病床確保計画')
              }}
            </caption>
            <thead>
              <tr>
                <th />
                <th>{{ $t('フェーズ') }}0<br />{{ $t('未発生期') }}</th>
                <th>{{ $t('フェーズ') }}1<br />{{ $t('発生初期') }}</th>
                <th>{{ $t('フェーズ') }}2<br />{{ $t('発生拡大期') }}</th>
                <th>{{ $t('フェーズ') }}3<br />{{ $t('まん延期') }}</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>{{ $t('指標') }}</td>
                <td>{{ $t('すべての医療機関の感染症病床が利用できる') }}</td>
                <td>{{ $t('感染症病床に余裕がある') }}</td>
                <td>
                  <span>{{ $t('一部の医療機関の感染症病床が満床') }}</span>
                  <span>{{ $t('半数の感染症病床に患者を収容') }}</span>
                </td>
                <td>
                  <span>{{ $t('全ての医療機関の感染症病床が満床') }}</span>
                  <span>{{ $t('重点医療機関等の病床の利用が進んだ') }}</span>
                </td>
              </tr>
              <tr>
                <td>{{ $t('確保病床') }}</td>
                <td>
                  <div>150{{ $t('床') }}</div>
                  <span>
                    ({{ $t('軽中症') }} 130 / {{ $t('Common.重症') }} 20)
                  </span>
                </td>
                <td>
                  <div>150{{ $t('床') }}</div>
                  <span>
                    ({{ $t('軽中症') }} 130 / {{ $t('Common.重症') }} 20)
                  </span>
                </td>
                <td>
                  <div>250{{ $t('床') }}</div>
                  <span>
                    ({{ $t('軽中症') }} 220 / {{ $t('Common.重症') }} 30)
                  </span>
                </td>
                <td>
                  <div>350{{ $t('床') }}</div>
                  <span>
                    ({{ $t('軽中症') }} 305 / {{ $t('Common.重症') }} 45)
                  </span>
                </td>
              </tr>
              <tr>
                <td>{{ $t('宿泊療養部屋数') }}</td>
                <td>85{{ $t('室') }}</td>
                <td>85{{ $t('室') }}</td>
                <td>85{{ $t('室') }}</td>
                <td>300{{ $t('室') }}</td>
              </tr>
              <tr>
                <td>{{ $t('病床等計') }}</td>
                <td>235{{ $t('床') }}</td>
                <td>235{{ $t('床') }}</td>
                <td>335{{ $t('床') }}</td>
                <td>650{{ $t('床') }}</td>
              </tr>
            </tbody>
          </table>
          <div :class="$style.bedExternalLink">
            <div>
              <app-link :to="$t('ExtLink.岩手県17_2.url')">
                {{ $t('ExtLink.岩手県17_2.text') }}
              </app-link>
            </div>
            <div>
              <app-link :to="$t('ExtLink.岩手県19_41.url')">
                {{ $t('ExtLink.岩手県19_41.text') }}
              </app-link>
            </div>
          </div>
        </template>
      </hospitalized-time-stacked-bar-chart>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script>
import AppLink from '@/components/AppLink.vue'
import HospitalizedTimeStackedBarChart from '@/components/HospitalizedTimeStackedBarChart.vue'
import PositiveStatus from '@/data/positive_status.json'
import { getNumberToLocaleStringFunction } from '@/utils/monitoringStatusValueFormatters.ts'

export default {
  components: {
    HospitalizedTimeStackedBarChart,
    AppLink,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const { data } = PositiveStatus
    const hospital = data.map((data) => data.hospital)
    const hotel = data.map((data) => data.hotel)
    const waiting = data.map((data) => data.waiting)

    const hospitalizedGraph = [hospital, hotel, waiting]

    const hospitalizedItems = [
      this.$t('Common.入院'),
      this.$t('Common.宿泊療養'),
      this.$t('Common.調整中'),
    ]

    const hospitalizedLabels = data.map((data) => data.date)

    const hospitalizedDataLabels = hospitalizedItems.map((d) => d)
    const hospitalizedTableLabels = hospitalizedItems.map((d) => d)

    const getFormatter = () => {
      return getNumberToLocaleStringFunction()
    }

    return {
      PositiveStatus,
      hospitalizedGraph,
      hospitalizedItems,
      hospitalizedLabels,
      hospitalizedDataLabels,
      hospitalizedTableLabels,
      getFormatter,
    }
  },
}
</script>

<style lang="scss" module>
table {
  &.beds {
    border-collapse: collapse;
    margin-bottom: 5px;
    caption {
      font-weight: bold;
      margin-bottom: 12px;
    }
    thead {
      tr {
        th {
          background-color: $gray-5;
          border: 1px solid #999;
          width: 23%;
          &:first-child {
            width: 8%;
          }
        }
      }
    }
    tbody {
      tr {
        td {
          border: 1px solid #999;
          text-align: center;
          span {
            @include font-size(11, true);
            &:first-child {
              display: inline-block;
              margin-bottom: 10px;
            }
          }
          &:first-child {
            background-color: $gray-5;
            font-weight: bold;
          }
        }
        &:nth-child(1) {
          td {
            &:nth-child(n + 2) {
              vertical-align: top;
            }
          }
        }
      }
    }
  }
}
.bedExternalLink {
  text-align: right;
}
</style>

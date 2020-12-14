<template>
  <v-col cols="12" md="6" class="DataCard">
    <client-only>
      <hospitalized-time-stacked-bar-chart
        :title="$t('入院と宿泊療養の推移')"
        :title-id="'number-of-hospitalized'"
        :chart-id="'time-stacked-bar-chart-hospitalized'"
        :chart-data="hospitalizedGraph"
        :date="PositiveStatus.date"
        :items="hospitalizedItems"
        :labels="hospitalizedLabels"
        :unit="$t('人')"
        :data-labels="hospitalizedDataLabels"
        :table-labels="hospitalizedTableLabels"
      >
        <template #additionalDescription>
          <span>{{ $t('（参考）') }}</span>
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
                  <div>150</div>
                  <span>({{ $t('軽中症') }} 130 / {{ $t('重症') }} 20)</span>
                </td>
                <td>
                  <div>150</div>
                  <span>({{ $t('軽中症') }} 130 / {{ $t('重症') }} 20)</span>
                </td>
                <td>
                  <div>250</div>
                  <span>({{ $t('軽中症') }} 220 / {{ $t('重症') }} 30)</span>
                </td>
                <td>
                  <div>350</div>
                  <span>({{ $t('軽中症') }} 305 / {{ $t('重症') }} 45)</span>
                </td>
              </tr>
              <tr>
                <td>{{ $t('宿泊療養部屋数') }}</td>
                <td>85</td>
                <td>85</td>
                <td>85</td>
                <td>300</td>
              </tr>
              <tr>
                <td>{{ $t('病床等計') }}</td>
                <td>235</td>
                <td>235</td>
                <td>335</td>
                <td>650</td>
              </tr>
            </tbody>
          </table>
          <div :class="$style.bedExternalLink">
            <div>
              <app-link
                to="https://www.pref.iwate.jp/_res/projects/default_project/_page_/001/028/231/20200710_03.pdf#page=3"
              >
                {{ $t('岩手県 / 第17回本部員会議資料【資料2】[PDF]') }}
              </app-link>
            </div>
            <div>
              <app-link
                to="https://www.pref.iwate.jp/_res/projects/default_project/_page_/001/028/231/20200806_04_1_1.pdf#page=2"
              >
                {{ $t('岩手県 / 第19回本部員会議資料【資料4-1】[PDF]') }}
              </app-link>
            </div>
          </div>
        </template>
      </hospitalized-time-stacked-bar-chart>
    </client-only>
  </v-col>
</template>

<script>
import PositiveStatus from '@/data/positive_status.json'
import HospitalizedTimeStackedBarChart from '@/components/HospitalizedTimeStackedBarChart.vue'
import { getNumberToLocaleStringFunction } from '@/utils/monitoringStatusValueFormatters.ts'
import AppLink from '@/components/AppLink.vue'

export default {
  components: {
    HospitalizedTimeStackedBarChart,
    AppLink,
  },
  data() {
    const { data } = PositiveStatus
    const hospital = data.map((data) => data.hospital)
    const hotel = data.map((data) => data.hotel)

    const hospitalizedGraph = [hospital, hotel]

    const hospitalizedItems = [this.$t('入院'), this.$t('宿泊療養')]

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

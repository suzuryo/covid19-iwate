<template>
  <v-col cols="12" md="6" class="DataCard">
    <client-only>
      <dashed-rectangle-time-bar-chart
        :title-id="'number-of-hospitalized'"
        :info-titles="[$t('入院患者数')]"
        :chart-id="'dashed-rectangle-time-bar-chart-hospitalized'"
        :chart-data="patientsGraph"
        :date="positiveStatus.date"
        :unit="$t('人')"
        :dashed-rectangle-range="'2020-05-11'"
        :added-value="0"
        :table-labels="tableLabels"
      >
        <template v-slot:additionalDescription>
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
                <td>指標</td>
                <td>{{ $t('すべての医療機関の感染病床が利用できる') }}</td>
                <td>{{ $t('感染症病症に余裕がある') }}</td>
                <td>
                  <span>{{ $t('一部の医療機関の感染症病症が満床') }}</span>
                  <span>{{ $t('半数の感染症病床に患者を収容') }}</span>
                </td>
                <td>
                  <span>{{ $t('全ての医療機関の感染症病症が満床') }}</span>
                  <span>{{ $t('重点医療機関等の病床の利用が進んだ') }}</span>
                </td>
              </tr>
              <tr>
                <td>{{ $t('確保病床') }}</td>
                <td>
                  <div>150{{ $t('床') }}</div>
                  <span>({{ $t('軽中症') }}130 / {{ $t('重症') }}20)</span>
                </td>
                <td>
                  <div>150{{ $t('床') }}</div>
                  <span>({{ $t('軽中症') }}130 / {{ $t('重症') }}20)</span>
                </td>
                <td>
                  <div>250{{ $t('床') }}</div>
                  <span>({{ $t('軽中症') }}220 / {{ $t('重症') }}30)</span>
                </td>
                <td>
                  <div>350{{ $t('床') }}</div>
                  <span>({{ $t('軽中症') }}305 / {{ $t('重症') }}45)</span>
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
            <external-link
              url="https://www.pref.iwate.jp/_res/projects/default_project/_page_/001/028/231/20200806_04_1_1.pdf"
            >
              {{ $t('第19回本部員会議資料【資料4-1】[PDF]') }}
            </external-link>
          </div>
        </template>
      </dashed-rectangle-time-bar-chart>
    </client-only>
  </v-col>
</template>

<script>
import positiveStatus from '@/data/positive_status.json'
import formatGraph from '@/utils/formatGraph'
import DashedRectangleTimeBarChart from '@/components/DashedRectangleTimeBarChart.vue'
import ExternalLink from '@/components/ExternalLink.vue'

export default {
  components: {
    DashedRectangleTimeBarChart,
    ExternalLink,
  },
  data() {
    const formatData = positiveStatus.data
      .filter((d) => new Date(d.date) >= new Date('2020-03-06'))
      .map((d) => ({
        日付: new Date(d.date),
        小計: d.hospitalized,
      }))
    // 入院患者数グラフ
    const patientsGraph = formatGraph(formatData)
    const tableLabels = [this.$t('入院患者数')]

    return {
      positiveStatus,
      patientsGraph,
      tableLabels,
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

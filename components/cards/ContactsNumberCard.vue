<template>
  <v-col cols="12" md="6" class="DataCard">
    <client-only>
      <time-bar-chart
        :title="$t('一般相談 受付件数')"
        :title-id="'number-of-reports-to-covid19-telephone-advisory-center'"
        :chart-id="'time-bar-chart-contacts'"
        :chart-data="contactsGraph"
        :date="Data.contacts.date"
        :unit="$t('件.reports')"
        :url="'https://catalog.data.metro.tokyo.lg.jp/dataset/t000010d0000000071'"
      >
        <!-- 件.reports = 窓口相談件数 -->
        <template v-slot:additionalDescription>
          <span>{{ $t('（注）') }}</span>
          <ul>
            <li>
              {{
                $t(
                  '「新型コロナウイルス感染症に関する疑問や心配事がある方からの一般相談」を計上'
                )
              }}
            </li>
            <li>
              {{ $t('コールセンター・各保健所等への受付件数の合計') }}
            </li>
            <li>
              {{ $t('窓口を開設した2020年1月21日からのデータを表示') }}
            </li>
            <li>
              {{
                $t(
                  '速報値として公表するものであり、後日確定データとして修正される場合がある'
                )
              }}
            </li>
            <!--
            <li>
              {{
                $t(
                  '曜日などによる数値のばらつきにより、日々の結果が変動するため、こうしたばらつきを平準化し全体の傾向を見る趣旨から、過去7日間の移動平均値を折れ線グラフで示す（例えば、8月7日の移動平均値は、8月1日から8月7日までの実績値を平均したもの）'
                )
              }}
            </li>
            -->
          </ul>
        </template>
      </time-bar-chart>
    </client-only>
  </v-col>
</template>

<script>
import Data from '@/data/data.contacts.json'
import formatGraph from '@/utils/formatGraph'
import TimeBarChart from '@/components/TimeBarChart.vue'

export default {
  components: {
    TimeBarChart,
  },
  data() {
    // 相談件数
    const contactsGraph = formatGraph(Data.contacts.data)

    return {
      Data,
      contactsGraph,
    }
  },
}
</script>

<template>
  <v-col id="WeeklyMapCard" cols="12" :md="md" class="DataCard">
    <client-only>
      <weekly-map
        :title="`直近1週間の陽性数`"
        :title-id="'weekly-map'"
        :date="date"
        :map-data="mapData"
        :info="info"
      >
        <template #notes>
          <ul>
            <li>
              直近1週間の新規陽性者数を、居住地の市町村ごとに分類し、色を加えたもの
            </li>
            <li>
              直近1週間の新規陽性者数が多い地域は色が濃く、少ない地域は色が薄い
            </li>
            <li>
              居住地が市町村名ではなく「〇〇保健所管内」と発表された場合は、その管内の市町村すべてに+1する
            </li>
          </ul>
        </template>
      </weekly-map>
      <slot name="breadCrumb" />
    </client-only>
  </v-col>
</template>

<script lang="ts">
import dayjs from 'dayjs'
import Vue from 'vue'

import WeeklyMap from '@/components/WeeklyMap.vue'
import Data from '@/data/data.json'
import PatientMunicipalities from '@/data/patient_municipalities.json'
import { Cities, MapData } from '@/types/weekly-map'

export default Vue.extend({
  components: {
    WeeklyMap,
  },
  props: {
    md: {
      type: String,
      default: '6',
    },
  },
  data() {
    const cities: Cities = {
      盛岡市: {
        count: 0,
        area: '盛岡市保健所管内',
      },
      宮古市: {
        count: 0,
        area: '宮古保健所管内',
      },
      大船渡市: {
        count: 0,
        area: '大船渡保健所管内',
      },
      花巻市: {
        count: 0,
        area: '中部保健所管内',
      },
      北上市: {
        count: 0,
        area: '中部保健所管内',
      },
      久慈市: {
        count: 0,
        area: '久慈保健所管内',
      },
      遠野市: {
        count: 0,
        area: '中部保健所管内',
      },
      一関市: {
        count: 0,
        area: '一関保健所管内',
      },
      陸前高田市: {
        count: 0,
        area: '大船渡保健所管内',
      },
      釜石市: {
        count: 0,
        area: '釜石保健所管内',
      },
      二戸市: {
        count: 0,
        area: '二戸保健所管内',
      },
      八幡平市: {
        count: 0,
        area: '県央保健所管内',
      },
      奥州市: {
        count: 0,
        area: '奥州保健所管内',
      },
      滝沢市: {
        count: 0,
        area: '県央保健所管内',
      },
      雫石町: {
        count: 0,
        area: '県央保健所管内',
      },
      葛巻町: {
        count: 0,
        area: '県央保健所管内',
      },
      岩手町: {
        count: 0,
        area: '県央保健所管内',
      },
      紫波町: {
        count: 0,
        area: '県央保健所管内',
      },
      矢巾町: {
        count: 0,
        area: '県央保健所管内',
      },
      西和賀町: {
        count: 0,
        area: '中部保健所管内',
      },
      金ケ崎町: {
        count: 0,
        area: '奥州保健所管内',
      },
      平泉町: {
        count: 0,
        area: '一関保健所管内',
      },
      住田町: {
        count: 0,
        area: '大船渡保健所管内',
      },
      大槌町: {
        count: 0,
        area: '釜石保健所管内',
      },
      山田町: {
        count: 0,
        area: '宮古保健所管内',
      },
      岩泉町: {
        count: 0,
        area: '宮古保健所管内',
      },
      田野畑村: {
        count: 0,
        area: '宮古保健所管内',
      },
      普代村: {
        count: 0,
        area: '久慈保健所管内',
      },
      軽米町: {
        count: 0,
        area: '二戸保健所管内',
      },
      野田村: {
        count: 0,
        area: '久慈保健所管内',
      },
      九戸村: {
        count: 0,
        area: '二戸保健所管内',
      },
      洋野町: {
        count: 0,
        area: '久慈保健所管内',
      },
      一戸町: {
        count: 0,
        area: '二戸保健所管内',
      },
      県外: {
        count: 0,
        area: '県外',
      },
    }

    Data.patients.data
      .filter((a: any) =>
        dayjs(a.確定日).isAfter(
          dayjs(
            Data.patients_summary.data[Data.patients_summary.data.length - 1]
              .日付
          ).add(-8, 'days') // 確定日の翌日に発表があるので -7 じゃなくて -8
        )
      )
      .forEach((patient) => {
        // 居住地が保健所管内での発表の場合は対象の市町村を取得
        const areas = Object.keys(cities).filter(
          (key) => cities[key].area === patient.居住地
        )
        if (areas.length === 0) {
          // 居住地が市町村での発表の場合
          cities[patient.居住地].count++
        } else {
          // 居住地が保健所管内での発表の場合
          areas.forEach((a) => {
            cities[a].count++
          })
        }
      })

    // データを追加
    const mapData: MapData = PatientMunicipalities.datasets.data
      .filter((d: any) => d.label !== '小計')
      .map((d: any) => {
        return {
          ruby: this.$t(d.ruby),
          label: this.$t(d.label),
          count: d.count,
          area: cities[d.label].area,
          last7days: cities[d.label].count,
        }
      })

    const date = dayjs(PatientMunicipalities.date).format('YYYY/MM/DD HH:mm')

    const info = {
      lText: '0',
      lTextBefore: '岩手県全域',
      sText: '居住が県外で県内滞在も含む',
    }
    return {
      date,
      mapData,
      info,
    }
  },
})
</script>

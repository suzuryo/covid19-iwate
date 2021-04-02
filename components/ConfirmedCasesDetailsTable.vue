<template>
  <ul :class="$style.container">
    <li :class="[$style.box, $style.parent]">
      <div :class="$style.content">
        <span> {{ $t('Common.陽性者数') }} ({{ $t('Common.累計') }}) </span>
        <span>
          <strong>
            {{ 陽性者数.toLocaleString() }}
          </strong>
          <span :class="$style.dailyDiff">
            [ {{ dailyDiff(陽性者数前日差) }} ]
          </span>
        </span>
      </div>
      <ul :class="$style.group">
        <li :class="[$style.box, $style.parent]">
          <div :class="$style.content">
            <span>{{ $t('Common.入院') }}</span>
            <span>
              <strong>
                {{ 入院.toLocaleString() }}
              </strong>
              <span :class="$style.dailyDiff">
                [ {{ dailyDiff(入院前日差) }} ]
              </span>
            </span>
          </div>
          <ul :class="$style.group">
            <li :class="[$style.box]">
              <div :class="$style.content">
                <span>{{ $t('Common.重症') }}</span>
                <span>
                  <strong>
                    {{ 重症.toLocaleString() }}
                  </strong>
                  <span :class="$style.dailyDiff">
                    [ {{ dailyDiff(重症前日差) }} ]
                  </span>
                </span>
              </div>
            </li>
          </ul>
        </li>
        <li :class="[$style.box]">
          <div :class="$style.content">
            <span>{{ $t('Common.宿泊療養') }}</span>
            <span>
              <strong>
                {{ 宿泊療養.toLocaleString() }}
              </strong>
              <span :class="$style.dailyDiff">
                [ {{ dailyDiff(宿泊療養前日差) }} ]
              </span>
            </span>
          </div>
        </li>
        <li :class="[$style.box]">
          <div :class="$style.content">
            <span>{{ $t('ConfirmedCasesDetailsCard.legends[0]') }}</span>
            <span>
              <strong>
                {{ 自宅療養.toLocaleString() }}
              </strong>
              <span :class="$style.dailyDiff">
                [ {{ dailyDiff(自宅療養前日差) }} ]
              </span>
            </span>
          </div>
        </li>
        <li :class="[$style.box]">
          <div :class="$style.content">
            <span>{{ $t('ConfirmedCasesDetailsCard.legends[1]') }}</span>
            <span>
              <strong>
                {{ 調整中.toLocaleString() }}
              </strong>
              <span :class="$style.dailyDiff">
                [ {{ dailyDiff(調整中前日差) }} ]
              </span>
            </span>
          </div>
        </li>
        <li :class="$style.box">
          <div :class="$style.content">
            <span>{{ $t('ConfirmedCasesDetailsCard.legends[2]') }}</span>
            <span>
              <span :class="$style.perTestPositive">
                ({{ perTestPositive(this.退院等) }}{{ $t('Common.%') }})
              </span>
              <strong>
                {{ 退院等.toLocaleString() }}
              </strong>
              <span :class="$style.dailyDiff">
                [ {{ dailyDiff(退院等前日差) }} ]
              </span>
            </span>
          </div>
        </li>
        <li :class="$style.box">
          <div :class="$style.content">
            <span>{{ $t('ConfirmedCasesDetailsCard.legends[3]') }}</span>
            <span>
              <span :class="$style.perTestPositive">
                ({{ perTestPositive(this.死亡) }}{{ $t('Common.%') }})
              </span>
              <strong>
                {{ 死亡.toLocaleString() }}
              </strong>
              <span :class="$style.dailyDiff">
                [ {{ dailyDiff(死亡前日差) }} ]
              </span>
            </span>
          </div>
        </li>
      </ul>
    </li>
  </ul>
</template>

<script lang="ts">
import Vue from 'vue'

/* eslint-disable vue/prop-name-casing */
export default Vue.extend({
  props: {
    date: {
      type: String,
      required: true,
    },
    陽性者数: {
      type: Number,
      required: true,
    },
    陽性者数前日差: {
      type: Number,
      required: true,
    },
    入院: {
      type: Number,
      required: true,
    },
    入院前日差: {
      type: Number,
      required: true,
    },
    宿泊療養: {
      type: Number,
      required: true,
    },
    宿泊療養前日差: {
      type: Number,
      required: true,
    },
    自宅療養: {
      type: Number,
      required: true,
    },
    自宅療養前日差: {
      type: Number,
      required: true,
    },
    調整中: {
      type: Number,
      required: true,
    },
    調整中前日差: {
      type: Number,
      required: true,
    },
    重症: {
      type: Number,
      required: true,
    },
    重症前日差: {
      type: Number,
      required: true,
    },
    死亡: {
      type: Number,
      required: true,
    },
    死亡前日差: {
      type: Number,
      required: true,
    },
    退院等: {
      type: Number,
      required: true,
    },
    退院等前日差: {
      type: Number,
      required: true,
    },
  },
  methods: {
    perTestPositive(a: number): string {
      return ((a / this.陽性者数) * 100).toFixed(1)
    },
    dailyDiff(a: number): string {
      if (a > 0) {
        return `+${a}`
      } else if (a === 0) {
        return `±${a}`
      } else {
        return `${a}`
      }
    },
  },
})
</script>

<style lang="scss" module>
$default-bdw: 3px;
$default-boxdiff: 35px;

// .container > .box > (.group > .box > ...) .pillar > .content

.container {
  width: 100%;
  box-sizing: border-box;
  color: $green-1;
  line-height: 1.35;

  * {
    box-sizing: border-box;
  }
  // override default styles
  padding-left: 0 !important;

  ul {
    padding-left: 0;
  }
}

.group {
  flex: 0 0 auto;
  padding-left: $default-bdw !important;
  border-top: $default-bdw solid $green-1;
  border-left: $default-bdw solid $green-1;
}

.content {
  padding: 5px 10px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  border: $default-bdw solid $green-1;

  > span {
    display: block;

    @include font-size(14);

    &:first-child {
      text-align: left;
      margin-top: 1px;
      flex-shrink: 2;
    }

    &:last-child {
      margin-left: 10px;
      text-align: right;
      // white-space: nowrap;
      flex-shrink: 1;
    }

    &:not(:last-child) {
      overflow-wrap: break-word;
    }
  }

  strong {
    @include font-size(16);
  }

  span.perTestPositive {
    margin-right: 1em;
    @include font-size(11);
  }

  span.dailyDiff {
    display: inline-block;
    width: 3em;
    @include font-size(11);
  }
}

.box {
  display: block;
  margin-top: $default-bdw;

  &.parent {
    border-top: $default-bdw solid $green-1;
    border-left: $default-bdw solid $green-1;
    position: relative;
    padding-left: $default-boxdiff - $default-bdw * 2;

    &::after {
      content: '';
      display: block;
      position: absolute;
      left: -1px;
      bottom: 0;
      width: $default-boxdiff - $default-bdw - 2;
      border-bottom: $default-bdw solid $green-1;
    }

    > .content {
      margin-left: -($default-boxdiff - $default-bdw * 2);
      width: calc(100% + #{($default-boxdiff - $default-bdw * 2)});
      border-top: none;
      border-left: none;
      border-bottom: none;
    }
  }
}

@function px2vw($px, $vw: 0) {
  @if $vw > 0 {
    @return ceil($px / $vw * 100000vw) / 1000;
  } @else {
    @return $px * 1px;
  }
}

@mixin override($vw, $bdw, $fz, $boxdiff) {
  .group {
    padding-left: px2vw($bdw, $vw) !important;
    border-top: px2vw($bdw, $vw) solid $green-1;
    border-left: px2vw($bdw, $vw) solid $green-1;
  }

  .content {
    padding: px2vw(5, $vw) px2vw(10, $vw);
    border: px2vw($bdw, $vw) solid $green-1;

    > span {
      @include font-size($fz);

      &:first-child {
        margin-top: px2vw(1, $vw);
      }

      &:last-child {
        margin-left: 10px;
      }
    }

    strong {
      @include font-size($fz + 2);
    }
  }

  .box {
    margin-top: px2vw($bdw, $vw);

    &.parent {
      border-top: px2vw($bdw, $vw) solid $green-1;
      border-left: px2vw($bdw, $vw) solid $green-1;
      padding-left: px2vw($boxdiff, $vw) - px2vw($bdw, $vw) * 2;

      &::after {
        width: px2vw($boxdiff - $bdw, $vw);
        border-bottom: px2vw($bdw, $vw) solid $green-1;
      }

      > .content {
        margin-left: -(px2vw($boxdiff, $vw) - px2vw($bdw, $vw) * 2);
        width: calc(100% + #{(px2vw($boxdiff, $vw) - px2vw($bdw, $vw) * 2)});
      }
    }
  }
}

// Vuetify Breakpoints: Large (1264)
@include lessThan(1263) {
  @include override(1263, 3, 14, 35);
}

// Vuetify Breakpoints: Small (960)
@include lessThan(959) {
  @include override(960, 3, 14, 35);
}

// Vuetify Breakpoints: Extra Small (600)
@include lessThan(600) {
  @include override(600, 3, 14, 35);
}
</style>

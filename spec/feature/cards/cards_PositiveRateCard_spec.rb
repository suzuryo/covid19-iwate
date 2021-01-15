require 'spec_helper'
require_relative '../../lib/PositiveRateCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/positive-rate]' do

    before do
      visit '/cards/positive-rate'
      render_lazy_contents
      page.scroll_to('#PositiveRateCard')
    end

    describe '検査の陽性率(PositiveRateCard)' do
      it '項目の値' do
        positive_rate_card

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#PositiveRateCard nav ul.v-breadcrumbs')
        expect(find('#PositiveRateCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq JA_JSON['Common']['ホーム']
        expect(find('#PositiveRateCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '検査の陽性率'
      end
    end
  end
end

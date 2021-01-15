require 'spec_helper'
require_relative '../../lib/UntrackedRateCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/untracked-rate]' do

    before do
      visit '/cards/untracked-rate'
      render_lazy_contents
      page.scroll_to('#UntrackedRateCard')
    end

    describe '接触歴等不明者数(7日間移動平均)(UntrackedRateCard)' do
      it '項目の値' do
        untracked_rate_card

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#UntrackedRateCard nav ul.v-breadcrumbs')
        expect(find('#UntrackedRateCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq JA_JSON['Common']['ホーム']
        expect(find('#UntrackedRateCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '接触歴等不明者数(7日間移動平均)'
      end
    end

  end
end

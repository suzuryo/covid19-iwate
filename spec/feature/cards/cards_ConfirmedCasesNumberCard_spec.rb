require 'spec_helper'
require_relative '../../lib/ConfirmedCasesNumberCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/number-of-confirmed-cases]' do

    before do
      visit '/cards/number-of-confirmed-cases'
      render_lazy_contents
      page.scroll_to('#ConfirmedCasesNumberCard')
    end

    describe '報告日別による陽性者数の推移(ConfirmedCasesNumberCard)' do
      it '項目の値' do
        confirmed_cases_number_card

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#ConfirmedCasesNumberCard nav ul.v-breadcrumbs')
        expect(find('#ConfirmedCasesNumberCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq JA_JSON['Common']['ホーム']
        expect(find('#ConfirmedCasesNumberCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '報告日別による陽性者数の推移'
      end
    end

  end
end

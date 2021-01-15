require 'spec_helper'
require_relative '../../lib/ConfirmedCasesDetailsCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/details-of-confirmed-cases]' do

    before do
      visit '/cards/details-of-confirmed-cases'
      render_lazy_contents
      page.scroll_to('#ConfirmedCasesDetailsCard')
    end

    describe '検査陽性者の状況(ConfirmedCasesDetailsCard)' do
      it '項目の値' do
        confirmed_cases_details_card

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#ConfirmedCasesDetailsCard nav ul.v-breadcrumbs')
        expect(find('#ConfirmedCasesDetailsCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq JA_JSON['Common']['ホーム']
        expect(find('#ConfirmedCasesDetailsCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '検査陽性者の状況'
      end
    end

  end
end

require 'spec_helper'
require_relative '../../lib/ConfirmedCasesByMunicipalitiesCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/number-of-confirmed-cases-by-municipalities]' do

    before do
      visit '/cards/number-of-confirmed-cases-by-municipalities'
      render_lazy_contents
      page.scroll_to('#ConfirmedCasesByMunicipalitiesCard')
    end

    describe '陽性患者数(市町村別)(ConfirmedCasesByMunicipalitiesCard)' do
      it '項目の値' do
        confirmed_cases_by_municipalities_card

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#ConfirmedCasesByMunicipalitiesCard nav ul.v-breadcrumbs')
        expect(find('#ConfirmedCasesByMunicipalitiesCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq JA_JSON['Common']['ホーム']
        expect(find('#ConfirmedCasesByMunicipalitiesCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '陽性患者数（市町村別）'
      end
    end

  end
end

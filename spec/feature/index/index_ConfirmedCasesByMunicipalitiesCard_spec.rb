require 'spec_helper'
require_relative '../../lib/ConfirmedCasesByMunicipalitiesCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
      render_lazy_contents
      page.scroll_to('#ConfirmedCasesByMunicipalitiesCard')
    end

    describe '陽性患者数(市町村別)(ConfirmedCasesByMunicipalitiesCard)' do
      it '項目の値' do
        confirmed_cases_by_municipalities_card

        # index の card 一覧では breadcrumbs は表示されない
        expect(page).not_to have_selector('#ConfirmedCasesByMunicipalitiesCard nav ul.v-breadcrumbs')
      end
    end

  end
end

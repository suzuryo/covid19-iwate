require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
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
        has_breadcrumbs(id: '#ConfirmedCasesByMunicipalitiesCard', title: '陽性患者数（市町村別）')
      end
    end

  end
end

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
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
        has_confirmed_cases_by_municipalities_card
        has_no_breadcrumbs(id: '#ConfirmedCasesByMunicipalitiesCard')
      end
    end
  end
end

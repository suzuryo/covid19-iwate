require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
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
        has_confirmed_cases_number_card
        has_breadcrumbs(id: '#ConfirmedCasesNumberCard', title: '報告日別による陽性者数の推移')
      end
    end

  end
end

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/ConfirmedCasesAttributesCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/attributes-of-confirmed-cases]' do
    before do
      visit '/cards/attributes-of-confirmed-cases'
      render_lazy_contents
      page.scroll_to('#ConfirmedCasesAttributesCard')
    end

    describe '陽性者の属性(ConfirmedCasesAttributesCard)' do
      it '項目の値' do
        has_confirmed_case_attributes_card
        has_breadcrumbs(id: '#ConfirmedCasesAttributesCard', title: JA_JSON['ConfirmedCasesAttributesCard']['title'])
      end
    end
  end
end

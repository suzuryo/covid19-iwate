require 'spec_helper'
require_relative '../../lib/ConfirmedCasesAttributesCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
      render_lazy_contents
      page.scroll_to('#ConfirmedCasesAttributesCard')
    end

    describe '陽性者の属性(ConfirmedCasesAttributesCard)' do
      it '項目の値' do
        confirmed_case_attributes_card

        # index の card 一覧では breadcrumbs は表示されない
        expect(page).not_to have_selector('#ConfirmedCasesAttributesCard nav ul.v-breadcrumbs')
      end
    end

  end
end

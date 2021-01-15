require 'spec_helper'
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
        confirmed_case_attributes_card

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#ConfirmedCasesAttributesCard nav ul.v-breadcrumbs')
        expect(find('#ConfirmedCasesAttributesCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq JA_JSON['Common']['ホーム']
        expect(find('#ConfirmedCasesAttributesCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['title']
      end
    end

  end
end

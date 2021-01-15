require 'spec_helper'
require_relative '../../lib/HospitalizedNumberCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/number-of-hospitalized]' do

    before do
      visit '/cards/number-of-hospitalized'
      render_lazy_contents
      page.scroll_to('#HospitalizedNumberCard')
    end

    describe '入院と宿泊療養の推移(HospitalizedNumberCard)' do
      it '項目の値' do
        hospitalized_number_card

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#HospitalizedNumberCard nav ul.v-breadcrumbs')
        expect(find('#HospitalizedNumberCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq JA_JSON['Common']['ホーム']
        expect(find('#HospitalizedNumberCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '入院と宿泊療養の推移'
      end
    end

  end
end

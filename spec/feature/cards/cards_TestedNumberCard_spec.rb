require 'spec_helper'
require_relative '../../lib/TestedNumberCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/number-of-tested]' do

    before do
      visit '/cards/number-of-tested'
      render_lazy_contents
      page.scroll_to('#TestedNumberCard')
    end

    describe '検査実施件数(TestedNumberCard)' do
      it '項目の値' do
        tested_number_card

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#TestedNumberCard nav ul.v-breadcrumbs')
        expect(find('#TestedNumberCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq JA_JSON['Common']['ホーム']
        expect(find('#TestedNumberCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '検査実施件数'
      end
    end

  end
end

require 'spec_helper'
require_relative '../../lib/PositiveRateCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
      render_lazy_contents
      page.scroll_to('#PositiveRateCard')
    end

    describe '検査の陽性率(PositiveRateCard)' do
      it '項目の値' do
        positive_rate_card

        # index の card 一覧では breadcrumbs は表示されない
        expect(page).not_to have_selector('#PositiveRateCard nav ul.v-breadcrumbs')
      end
    end
  end
end

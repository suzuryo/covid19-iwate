require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
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
        has_positive_rate_card
        has_no_breadcrumbs(id: '#PositiveRateCard')
      end
    end
  end
end

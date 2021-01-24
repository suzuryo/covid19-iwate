require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/TestedNumberCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do
    before do
      visit '/'
      render_lazy_contents
      page.scroll_to('#TestedNumberCard')
    end

    describe '検査実施件数(TestedNumberCard)' do
      it '項目の値' do
        has_tested_number_card
        has_no_breadcrumbs(id: '#TestedNumberCard')
      end
    end
  end
end

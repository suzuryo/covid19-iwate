require 'spec_helper'
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
        tested_number_card

        # index の card 一覧では breadcrumbs は表示されない
        expect(page).not_to have_selector('#TestedNumberCard nav ul.v-breadcrumbs')
      end
    end

  end
end

require 'spec_helper'
require_relative '../../lib/TelephoneAdvisoryReportsNumberCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
      render_lazy_contents
      page.scroll_to('#TelephoneAdvisoryReportsNumberCard')
    end

    describe '一般相談 受付件数(TelephoneAdvisoryReportsNumberCard)' do
      it '項目の値' do
        telephone_advisory_reports_number_card

        # index の card 一覧では breadcrumbs は表示されない
        expect(page).not_to have_selector('#TelephoneAdvisoryReportsNumberCard nav ul.v-breadcrumbs')
      end
    end

  end
end

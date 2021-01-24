require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/TelephoneAdvisoryReportsNumberCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/cards/number-of-reports-to-covid19-telephone-advisory-center]' do
    before do
      visit '/cards/number-of-reports-to-covid19-telephone-advisory-center'
      render_lazy_contents
      page.scroll_to('#TelephoneAdvisoryReportsNumberCard')
    end

    describe '一般相談 受付件数(TelephoneAdvisoryReportsNumberCard)' do
      it '項目の値' do
        has_telephone_advisory_reports_number_card
        has_breadcrumbs(id: '#TelephoneAdvisoryReportsNumberCard', title: '一般相談 受付件数')
      end
    end
  end
end

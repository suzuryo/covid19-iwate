require 'spec_helper'
require_relative '../../lib/TelephoneAdvisoryReportsNumberCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/number-of-reports-to-covid19-telephone-advisory-center]' do

    before do
      visit '/cards/number-of-reports-to-covid19-telephone-advisory-center'
      render_lazy_contents
      page.scroll_to('#TelephoneAdvisoryReportsNumberCard')
    end

    describe '一般相談 受付件数(TelephoneAdvisoryReportsNumberCard)' do
      it '項目の値' do
        telephone_advisory_reports_number_card

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#TelephoneAdvisoryReportsNumberCard nav ul.v-breadcrumbs')
        expect(find('#TelephoneAdvisoryReportsNumberCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq JA_JSON['Common']['ホーム']
        expect(find('#TelephoneAdvisoryReportsNumberCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '一般相談 受付件数'
      end
    end

  end
end

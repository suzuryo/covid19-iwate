require 'spec_helper'
require_relative '../../lib/MonitoringConsultationDeskReportsNumberCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/monitoring-number-of-reports-to-covid19-consultation-desk]' do

    before do
      visit '/cards/monitoring-number-of-reports-to-covid19-consultation-desk'
      render_lazy_contents
      page.scroll_to('#MonitoringConsultationDeskReportsNumberCard')
    end

    describe '受診・相談センター 受付件数(MonitoringConsultationDeskReportsNumberCard)' do
      it '項目の値' do
        monitoring_consultation_desk_reports_number_card

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#MonitoringConsultationDeskReportsNumberCard nav ul.v-breadcrumbs')
        expect(find('#MonitoringConsultationDeskReportsNumberCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq JA_JSON['Common']['ホーム']
        expect(find('#MonitoringConsultationDeskReportsNumberCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '受診・相談センター 受付件数'
      end
    end

  end
end

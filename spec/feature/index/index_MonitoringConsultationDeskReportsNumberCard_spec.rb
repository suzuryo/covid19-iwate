require 'spec_helper'
require_relative '../../lib/MonitoringConsultationDeskReportsNumberCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
      render_lazy_contents
      page.scroll_to('#MonitoringConsultationDeskReportsNumberCard')
    end

    describe '受診・相談センター 受付件数(MonitoringConsultationDeskReportsNumberCard)' do
      it '項目の値' do
        monitoring_consultation_desk_reports_number_card

        # index の card 一覧では breadcrumbs は表示されない
        expect(page).not_to have_selector('#MonitoringConsultationDeskReportsNumberCard nav ul.v-breadcrumbs')
      end
    end

  end
end

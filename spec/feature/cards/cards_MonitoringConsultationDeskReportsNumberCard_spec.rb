# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/MonitoringConsultationDeskReportsNumberCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/cards/monitoring-number-of-reports-to-covid19-consultation-desk]' do
    before do
      visit '/cards/monitoring-number-of-reports-to-covid19-consultation-desk'
      render_lazy_contents
      page.scroll_to('#MonitoringConsultationDeskReportsNumberCard')
    end

    describe 'meta' do
      it 'title' do
        expect(title).to eq "#{JA_JSON['MonitoringConsultationDeskReportsNumberCard']['title']} | #{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end

      it 'og:title' do
        # JS解釈したog:title
        expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
        # JS解釈しないog:title
        expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}/cards/monitoring-number-of-reports-to-covid19-consultation-desk").open).css('head meta[property="og:title"]').first['content']).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end
    end

    describe '受診・相談センター 受付件数(MonitoringConsultationDeskReportsNumberCard)' do
      it '項目の値' do
        has_monitoring_consultation_desk_reports_number_card
        has_breadcrumbs(id: '#MonitoringConsultationDeskReportsNumberCard', title: '受診・相談センター 受付件数')
      end
    end
  end
end

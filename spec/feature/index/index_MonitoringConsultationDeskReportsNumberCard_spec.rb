# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/]' do
    before do
      visit '/'
      page.scroll_to('.v-tabs')
      find('#app .v-tabs .v-slide-group__content a[href="#tab-1"]').click
      render_lazy_contents
    end

    describe '受診・相談センター 受付件数(MonitoringConsultationDeskReportsNumberCard)' do
      it '項目の値' do
        # MonitoringConsultationDeskReportsNumberCard は削除した
        expect(page).not_to have_selector('#MonitoringConsultationDeskReportsNumberCard')
        has_no_breadcrumbs(id: '#MonitoringConsultationDeskReportsNumberCard')
      end
    end
  end
end

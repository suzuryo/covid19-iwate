# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/MonitoringConfirmedCasesNumberPer100kCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit data[:path]
        render_lazy_contents
        page.scroll_to('#MonitoringConfirmedCasesNumberPer100kCard')
      end

      describe '盛岡市の直近1週間の新規患者数（対人口10万人）(MonitoringConfirmedCasesNumberPer100kCard)' do
        it '項目の値' do
          has_monitoring_confirmed_cases_number_per_100k_card(lang: lang, lang_json: data[:json])
          has_no_breadcrumbs(id: '#MonitoringConfirmedCasesNumberPer100kCard')
        end
      end
    end
  end
end

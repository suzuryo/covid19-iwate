# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/MonitoringConfirmedCasesNumberPer100kCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit "#{data[:path]}cards/monitoring-number-of-confirmed-cases-per-100k/"
        render_lazy_contents
        page.scroll_to('#MonitoringConfirmedCasesNumberPer100kCard')
      end

      describe 'meta' do
        it 'title' do
          expect(title).to eq "#{LOCALES[lang][:json]['MonitoringConfirmedCasesNumberPer100kCard']['title']} | #{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end

        it 'og:title' do
          # JS解釈したog:title
          expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
          # JS解釈しないog:title
          expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}#{data[:path]}cards/monitoring-number-of-confirmed-cases-per-100k/").open).css('head meta[property="og:title"]').first['content']).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end

        it 'og:url' do
          # JS解釈したog:url
          expect(find('head meta[property="og:url"]', visible: false)[:content]).to eq "https://iwate.stopcovid19.jp#{data[:path]}cards/monitoring-number-of-confirmed-cases-per-100k/"
          # JS解釈しないog:url
          expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}#{data[:path]}cards/monitoring-number-of-confirmed-cases-per-100k/").open).css('head meta[property="og:url"]').first['content']).to eq "https://iwate.stopcovid19.jp#{data[:path]}cards/monitoring-number-of-confirmed-cases-per-100k/"
        end
      end

      describe '盛岡市の直近1週間の新規患者数（対人口10万人）(MonitoringConfirmedCasesNumberPer100kCard)' do
        it '項目の値' do
          has_monitoring_confirmed_cases_number_per_100k_card(lang: lang, lang_json: data[:json])
          has_breadcrumbs(id: '#MonitoringConfirmedCasesNumberPer100kCard', title: data[:json]['MonitoringConfirmedCasesNumberPer100kCard']['title'], lang_json: data[:json])
        end
      end
    end
  end
end

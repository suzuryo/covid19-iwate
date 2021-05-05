# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/PositiveRateCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit "#{data[:path]}cards/positive-rate"
        render_lazy_contents
        page.scroll_to('#PositiveRateCard')
      end

      describe 'meta' do
        it 'title' do
          expect(title).to eq "#{LOCALES[lang][:json]['PositiveRateCard']['titles'].join(',')} | #{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end

        it 'og:title' do
          # JS解釈したog:title
          expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
          # JS解釈しないog:title
          expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}#{data[:path]}cards/positive-rate").open).css('head meta[property="og:title"]').first['content']).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end
      end

      describe '検査の陽性率(PositiveRateCard)' do
        it '項目の値' do
          has_positive_rate_card(lang: lang, lang_json: data[:json])
          has_breadcrumbs(id: '#PositiveRateCard', title: data[:json]['PositiveRateCard']['titles'][0], lang_json: data[:json])
        end
      end
    end
  end
end

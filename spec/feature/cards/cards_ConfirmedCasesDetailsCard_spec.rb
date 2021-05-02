# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/ConfirmedCasesDetailsCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit "#{data[:path]}cards/details-of-confirmed-cases"
        render_lazy_contents
        page.scroll_to('.ConfirmedCasesDetailsCard')
      end

      describe 'meta' do
        it 'title' do
          expect(title).to eq "#{LOCALES[lang][:json]['ConfirmedCasesDetailsCard']['title']} | #{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end

        it 'og:title' do
          # JS解釈したog:title
          expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
          # JS解釈しないog:title
          expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}/cards/details-of-confirmed-cases").open).css('head meta[property="og:title"]').first['content']).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
        end
      end

      describe '検査陽性者の状況(ConfirmedCasesDetailsCard)' do
        it '項目の値' do
          has_confirmed_cases_details_card(lang: lang, lang_json: data[:json])
          has_breadcrumbs(id: '#ConfirmedCasesDetailsCard', title: data[:json]['ConfirmedCasesDetailsCard']['title'], lang_json: data[:json])
        end
      end
    end
  end
end

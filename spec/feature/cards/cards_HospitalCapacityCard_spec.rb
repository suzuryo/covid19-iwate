# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/HospitalCapacityCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit "#{data[:path]}cards/hospital-capacity/"
        render_lazy_contents
        page.scroll_to('#HospitalCapacityCard')
      end

      describe 'meta' do
        it 'title' do
          expect(title).to eq "#{LOCALES[lang][:json]['HospitalCapacityCard']['title']} | #{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end

        it 'og:title' do
          # JS解釈したog:title
          expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
          # JS解釈しないog:title
          expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}#{data[:path]}cards/hospital-capacity/").open).css('head meta[property="og:title"]').first['content']).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end

        it 'og:url' do
          # JS解釈したog:url
          expect(find('head meta[property="og:url"]', visible: false)[:content]).to eq "https://iwate.stopcovid19.jp#{data[:path]}cards/hospital-capacity/"
          # JS解釈しないog:url
          expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}#{data[:path]}cards/hospital-capacity/").open).css('head meta[property="og:url"]').first['content']).to eq "https://iwate.stopcovid19.jp#{data[:path]}cards/hospital-capacity/"
        end
      end

      describe '入院病床の状況(HospitalCapacityCard)' do
        it '項目の値' do
          has_hospital_capacity_card(lang: lang, lang_json: data[:json])
          has_breadcrumbs(id: '#HospitalCapacityCard', title: data[:json]['HospitalCapacityCard']['title'], lang_json: data[:json])
        end
      end
    end
  end
end

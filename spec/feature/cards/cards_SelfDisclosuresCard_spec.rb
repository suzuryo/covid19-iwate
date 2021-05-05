# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/SelfDisclosuresCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit "#{data[:path]}cards/self-disclosures"
        render_lazy_contents
        page.scroll_to('#SelfDisclosuresCard')
      end

      describe 'meta' do
        it 'title' do
          expect(title).to eq "#{LOCALES[lang][:json]['SelfDisclosuresCard']['title']} | #{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end

        it 'og:title' do
          # JS解釈したog:title
          expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
          # JS解釈しないog:title
          expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}#{data[:path]}cards/self-disclosures").open).css('head meta[property="og:title"]').first['content']).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end
      end

      describe '自主公表(SelfDisclosuresCard)' do
        it '項目の値' do
          has_self_disclosures_card(lang: lang, lang_json: data[:json])
          has_breadcrumbs(id: '#SelfDisclosuresCard', title: data[:json]['SelfDisclosuresCard']['title'], lang_json: data[:json])
        end
      end
    end
  end
end

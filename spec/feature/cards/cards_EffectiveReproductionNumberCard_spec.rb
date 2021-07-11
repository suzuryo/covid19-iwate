# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/EffectiveReproductionNumberCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit "#{data[:path]}cards/effective-reproduction-number/"
        render_lazy_contents
        page.scroll_to('#EffectiveReproductionNumberCard')
      end

      describe 'meta' do
        it 'title' do
          expect(title).to eq "#{LOCALES[lang][:json]['EffectiveReproductionNumberCard']['title']} | #{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end

        it 'og:title' do
          # JS解釈したog:title
          expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
          # JS解釈しないog:title
          expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}#{data[:path]}cards/effective-reproduction-number/").open).css('head meta[property="og:title"]').first['content']).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end

        it 'og:url' do
          # JS解釈したog:url
          expect(find('head meta[property="og:url"]', visible: false)[:content]).to eq "https://iwate.stopcovid19.jp#{data[:path]}cards/effective-reproduction-number/"
          # JS解釈しないog:url
          expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}#{data[:path]}cards/effective-reproduction-number/").open).css('head meta[property="og:url"]').first['content']).to eq "https://iwate.stopcovid19.jp#{data[:path]}cards/effective-reproduction-number/"
        end
      end

      describe '実効再生産数（推定値）(EffectiveReproductionNumberCard)' do
        it '項目の値' do
          has_effective_reproduction_number_card(lang: lang, lang_json: data[:json])
          has_breadcrumbs(id: '#EffectiveReproductionNumberCard', title: data[:json]['EffectiveReproductionNumberCard']['title'], lang_json: data[:json])
        end
      end
    end
  end
end

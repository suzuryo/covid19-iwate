# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/ConfirmedCasesAttributesCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/cards/attributes-of-confirmed-cases]' do
    before do
      visit '/cards/attributes-of-confirmed-cases'
      render_lazy_contents
      page.scroll_to('#ConfirmedCasesAttributesCard')
    end

    describe 'meta' do
      it 'title' do
        expect(title).to eq "#{JA_JSON['ConfirmedCasesAttributesCard']['title']} | #{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end

      it 'og:title' do
        # JS解釈したog:title
        expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
        # JS解釈しないog:title
        expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}/cards/attributes-of-confirmed-cases").open).css('head meta[property="og:title"]').first['content']).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end
    end

    describe '陽性者の属性(ConfirmedCasesAttributesCard)' do
      it '項目の値' do
        has_confirmed_case_attributes_card
        has_breadcrumbs(id: '#ConfirmedCasesAttributesCard', title: JA_JSON['ConfirmedCasesAttributesCard']['title'])
      end
    end
  end
end

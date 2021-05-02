# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/TestedNumberCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/cards/number-of-tested]' do
    before do
      visit '/cards/number-of-tested'
      render_lazy_contents
      page.scroll_to('#TestedNumberCard')
    end

    describe 'meta' do
      it 'title' do
        expect(title).to eq "#{JA_JSON['TestedNumberCard']['title']} | #{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end

      it 'og:title' do
        # JS解釈したog:title
        expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
        # JS解釈しないog:title
        expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}/cards/number-of-tested").open).css('head meta[property="og:title"]').first['content']).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end
    end

    describe '検査実施件数(TestedNumberCard)' do
      it '項目の値' do
        has_tested_number_card
        has_breadcrumbs(id: '#TestedNumberCard', title: '検査実施件数')
      end
    end
  end
end

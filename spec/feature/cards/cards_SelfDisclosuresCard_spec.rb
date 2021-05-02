# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/SelfDisclosuresCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/cards/self-disclosures]' do
    before do
      visit '/cards/self-disclosures'
      render_lazy_contents
      page.scroll_to('#SelfDisclosuresCard')
    end

    describe 'meta' do
      it 'title' do
        expect(title).to eq "#{JA_JSON['SelfDisclosuresCard']['title']} | #{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end

      it 'og:title' do
        # JS解釈したog:title
        expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
        # JS解釈しないog:title
        expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}/cards/self-disclosures").open).css('head meta[property="og:title"]').first['content']).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end
    end

    describe '自主公表(SelfDisclosuresCard)' do
      it '項目の値' do
        has_self_disclosures_card
        has_breadcrumbs(id: '#SelfDisclosuresCard', title: JA_JSON['SelfDisclosuresCard']['title'])
      end
    end
  end
end

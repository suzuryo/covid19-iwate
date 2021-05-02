# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/UntrackedRateCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/cards/untracked-rate]' do
    before do
      visit '/cards/untracked-rate'
      render_lazy_contents
      page.scroll_to('#UntrackedRateCard')
    end

    describe 'meta' do
      it 'title' do
        expect(title).to eq "#{JA_JSON['UntrackedRateCard']['titles'].join(',')} | #{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end

      it 'og:title' do
        # JS解釈したog:title
        expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
        # JS解釈しないog:title
        expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}/cards/untracked-rate").open).css('head meta[property="og:title"]').first['content']).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end
    end

    describe '接触歴等不明者数(7日間移動平均)(UntrackedRateCard)' do
      it '項目の値' do
        has_untracked_rate_card
        has_breadcrumbs(id: '#UntrackedRateCard', title: '接触歴等不明者数(7日間移動平均)')
      end
    end
  end
end

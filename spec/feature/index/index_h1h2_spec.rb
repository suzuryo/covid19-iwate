# frozen_string_literal: true

require 'spec_helper'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/]' do
    before do
      visit '/'
      # render_lazy_contents
    end

    it 'title' do
      expect(title).to eq "#{JA_JSON['Common']['岩手の最新感染動向']} | #{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
    end

    it 'og:title' do
      # JS解釈したog:title
      expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      # JS解釈しないog:title
      expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}").open).css('head meta[property="og:title"]').first['content']).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
    end

    it 'h1/h2' do
      expect(find('#app > div > div.appContainer > div > div > header > h1').text).to eq "#{JA_JSON['Common']['新型コロナウイルス感染症']}\n#{JA_JSON['Common']['対策サイト']}"
      expect(find('#app > div > div.appContainer > main > div > div > div.MainPage > div.Header.mb-3 > div.header > h2').text).to eq (JA_JSON['Common']['岩手の最新感染動向']).to_s
    end

  end
end

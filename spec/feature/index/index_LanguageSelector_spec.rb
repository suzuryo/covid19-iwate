# frozen_string_literal: true

require 'spec_helper'

ja_json = JSON.parse(File.read(File.join(__dir__, '../../../assets/locales/ja.json')))
en_json = JSON.parse(File.read(File.join(__dir__, '../../../assets/locales/en.json')))

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/]' do
    before do
      visit '/'
      # render_lazy_contents
    end

    describe 'h1/h2' do
      it 'ja' do
        expect(find('#app > div > div.appContainer > div > div > header > h1').text).to eq "#{ja_json['Common']['新型コロナウイルス感染症']}\n#{ja_json['Common']['対策サイト']}"
        expect(find('#app > div > div.appContainer > main > div > div > div.MainPage > div.Header.mb-3 > div.header > h2').text).to eq (ja_json['Common']['岩手の最新感染動向']).to_s
      end

      it 'en' do
        find('.SideNavigation-OpenIcon').click
        find('.LanguageSelector-Menu option[value="en"]').select_option
        find('.SideNavigation-CloseIcon').click
        expect(find('#app > div > div.appContainer > div > div > header > h1').text).to eq "#{en_json['Common']['新型コロナウイルス感染症']}\n#{en_json['Common']['対策サイト']}"
        expect(find('#app > div > div.appContainer > main > div > div > div.MainPage > div.Header.mb-3 > div.header > h2').text).to eq (en_json['Common']['岩手の最新感染動向']).to_s
      end

      it 'ja -> en -> ja' do
        find('.SideNavigation-OpenIcon').click
        find('.LanguageSelector-Menu option[value="en"]').select_option
        find('.SideNavigation-CloseIcon').click
        find('.SideNavigation-OpenIcon').click
        find('.LanguageSelector-Menu option[value="ja"]').select_option
        find('.SideNavigation-CloseIcon').click
        expect(find('#app > div > div.appContainer > div > div > header > h1').text).to eq "#{ja_json['Common']['新型コロナウイルス感染症']}\n#{ja_json['Common']['対策サイト']}"
        expect(find('#app > div > div.appContainer > main > div > div > div.MainPage > div.Header.mb-3 > div.header > h2').text).to eq (ja_json['Common']['岩手の最新感染動向']).to_s
      end
    end
  end
end

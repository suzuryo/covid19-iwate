# frozen_string_literal: true

require 'spec_helper'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit "#{data[:path]}vaccine"
      end

      it 'title' do
        expect(title).to eq "#{LOCALES[lang][:json]['SideNavigation']['a'][10]} | #{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
      end

      it 'og:title' do
        # JS解釈したog:title
        expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        # JS解釈しないog:title
        expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}#{data[:path]}vaccine").open).css('head meta[property="og:title"]').first['content']).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
      end

      it 'h2' do
        expect(find('main.mainContainer > div > div.Vaccine > div.header > h2.pageTitle > span > svg > path')[:d]).to eq 'M11.15,15.18L9.73,13.77L11.15,12.35L12.56,13.77L13.97,12.35L12.56,10.94L13.97,9.53L15.39,10.94L16.8,9.53L13.97,6.7L6.9,13.77L9.73,16.6L11.15,15.18M3.08,19L6.2,15.89L4.08,13.77L13.97,3.87L16.1,6L17.5,4.58L16.1,3.16L17.5,1.75L21.75,6L20.34,7.4L18.92,6L17.5,7.4L19.63,9.53L9.73,19.42L7.61,17.3L3.08,21.84V19Z'
        expect(find('main.mainContainer > div > div.Vaccine > div.header > h2.pageTitle').text).to eq LOCALES[lang][:json]['SideNavigation']['a'][10].to_s
      end

      it '項目の値' do
        expect(find('main.mainContainer > div > div.Vaccine > div.StaticCard:nth-child(2) > h3').text).to eq LOCALES[lang][:json]['新型コロナウイルスワクチン接種に関する情報'].to_s
        expect(find('main.mainContainer > div > div.Vaccine > div.StaticCard:nth-child(2) > p').text).to eq LOCALES[lang][:json]['岩手県では、新型コロナウイルスワクチンの安全かつ円滑な接種に向けて、市町村や医療機関などと連携し対応しています。'].to_s

        expect(find('main.mainContainer > div > div.Vaccine > div.StaticCard:nth-child(3) > h3').text).to eq LOCALES[lang][:json]['新型コロナワクチンQ&A'].to_s
        expect(find('main.mainContainer > div > div.Vaccine > div.StaticCard:nth-child(3) > p').text).to eq LOCALES[lang][:json]['新型コロナウイルスワクチンに関する、厚生労働省のWebサイトです。'].to_s

        expect(find('main.mainContainer > div > div.Vaccine > div.StaticCard:nth-child(4) > h3').text).to eq LOCALES[lang][:json]['コロナワクチンナビ'].to_s
        expect(find('main.mainContainer > div > div.Vaccine > div.StaticCard:nth-child(4) > p').text).to eq LOCALES[lang][:json]['新型コロナウイルスワクチン接種に関する、厚生労働省のWebサイトです。'].to_s
      end
    end
  end
end



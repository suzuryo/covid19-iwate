# frozen_string_literal: true

require 'spec_helper'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit data[:path]
        render_lazy_contents
        find('header.SideNavigation-Header > .SideNavigation-OpenIcon').click
      end

      it '項目の値' do
        # 多言語選択メニュー
        expect(find('nav.SideNavigation-Menu > .SideNavigation-Language > .SideNavigation-Language label.SideNavigation-LanguageLabel').text).to eq data[:json]['Common']['多言語対応選択メニュー'].to_s
        expect(find('nav.SideNavigation-Menu > .SideNavigation-Language > .SideNavigation-Language div.LanguageSelector select#LanguageSelector > option:nth-child(1)').text.gsub(' ', '').strip).to eq '日本語'
        expect(find('nav.SideNavigation-Menu > .SideNavigation-Language > .SideNavigation-Language div.LanguageSelector select#LanguageSelector > option:nth-child(2)').text.gsub(' ', '').strip).to eq 'English'

        # MenuList 岩手の最新感染動向
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item:nth-child(1) > a > span.MenuList-Icon > span.MenuList-MdIcon > svg > path')[:d]).to eq 'M3,14L3.5,14.07L8.07,9.5C7.89,8.85 8.06,8.11 8.59,7.59C9.37,6.8 10.63,6.8 11.41,7.59C11.94,8.11 12.11,8.85 11.93,9.5L14.5,12.07L15,12C15.18,12 15.35,12 15.5,12.07L19.07,8.5C19,8.35 19,8.18 19,8A2,2 0 0,1 21,6A2,2 0 0,1 23,8A2,2 0 0,1 21,10C20.82,10 20.65,10 20.5,9.93L16.93,13.5C17,13.65 17,13.82 17,14A2,2 0 0,1 15,16A2,2 0 0,1 13,14L13.07,13.5L10.5,10.93C10.18,11 9.82,11 9.5,10.93L4.93,15.5L5,16A2,2 0 0,1 3,18A2,2 0 0,1 1,16A2,2 0 0,1 3,14Z'
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item:nth-child(1) > a > span.MenuList-Title').text).to eq data[:json]['Common']['岩手の最新感染動向']

        # MenuList 感染したか心配なとき
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item:nth-child(2) > a > span.MenuList-Icon > svg > path:nth-child(2)')[:d]).to eq 'M21.77 10.27a1.73 1.73 0 00-1.66 1.3h-1.68a6.44 6.44 0 00-1.58-3.81L18 6.57a1.71 1.71 0 002.09-.26 1.73 1.73 0 10-2.44-2.44A1.71 1.71 0 0017.43 6l-1.19 1.15a6.44 6.44 0 00-3.81-1.58V3.89a1.73 1.73 0 10-.86 0v1.68a6.44 6.44 0 00-3.81 1.58L6.57 6a1.71 1.71 0 00-.26-2.09 1.73 1.73 0 00-2.44 2.4A1.71 1.71 0 006 6.57l1.15 1.19a6.44 6.44 0 00-1.58 3.81H3.89a1.73 1.73 0 100 .86h1.68a6.44 6.44 0 001.58 3.81L6 17.43a1.71 1.71 0 00-2.09.26 1.73 1.73 0 002.44 2.44A1.71 1.71 0 006.57 18l1.19-1.19a6.44 6.44 0 003.81 1.58v1.68a1.73 1.73 0 10.86 0v-1.64a6.44 6.44 0 003.81-1.58L17.43 18a1.71 1.71 0 00.26 2.09 1.73 1.73 0 002.44-2.44 1.71 1.71 0 00-2.13-.22l-1.19-1.19a6.44 6.44 0 001.58-3.81h1.68a1.72 1.72 0 101.66-2.16zM6.5 12.75a.5.5 0 11.5.5.5.5 0 01-.5-.5zm3.5 3.5a.5.5 0 11.5-.5.5.5 0 01-.5.5zm0-2.5a1 1 0 111-1 1 1 0 01-1 1zm4 2.5a.5.5 0 11.5-.5.5.5 0 01-.5.5zm0-2.5a1 1 0 111-1 1 1 0 01-1 1zm0-4a1 1 0 111-1 1 1 0 01-1 1zm3 3.5a.5.5 0 11.5-.5.5.5 0 01-.5.5z'
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item:nth-child(2) > a > span.MenuList-Title').text).to eq data[:json]['SideNavigation']['a'][4]

        # MenuList ワクチン接種
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item:nth-child(3) > a > span.MenuList-Icon > span.MenuList-MdIcon > svg > path')[:d]).to eq 'M11.15,15.18L9.73,13.77L11.15,12.35L12.56,13.77L13.97,12.35L12.56,10.94L13.97,9.53L15.39,10.94L16.8,9.53L13.97,6.7L6.9,13.77L9.73,16.6L11.15,15.18M3.08,19L6.2,15.89L4.08,13.77L13.97,3.87L16.1,6L17.5,4.58L16.1,3.16L17.5,1.75L21.75,6L20.34,7.4L18.92,6L17.5,7.4L19.63,9.53L9.73,19.42L7.61,17.3L3.08,21.84V19Z'
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item:nth-child(3) > a > span.MenuList-Title').text).to eq data[:json]['SideNavigation']['a'][10]

        # MenuList 県民の皆様へ
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item:nth-child(4) > a > span.MenuList-Icon > span.MenuList-MdIcon > svg > path')[:d]).to eq 'M16 17V19H2V17S2 13 9 13 16 17 16 17M12.5 7.5A3.5 3.5 0 1 0 9 11A3.5 3.5 0 0 0 12.5 7.5M15.94 13A5.32 5.32 0 0 1 18 17V19H22V17S22 13.37 15.94 13M15 4A3.39 3.39 0 0 0 13.07 4.59A5 5 0 0 1 13.07 10.41A3.39 3.39 0 0 0 15 11A3.5 3.5 0 0 0 15 4Z'
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item:nth-child(4) > a > span.MenuList-Title').text).to eq data[:json]['SideNavigation']['a'][5]

        # MenuList 企業の皆様へ
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item.-border:nth-child(5) > a > span.MenuList-Icon > span.MenuList-MdIcon > svg > path')[:d]).to eq 'M18,15H16V17H18M18,11H16V13H18M20,19H12V17H14V15H12V13H14V11H12V9H20M10,7H8V5H10M10,11H8V9H10M10,15H8V13H10M10,19H8V17H10M6,7H4V5H6M6,11H4V9H6M6,15H4V13H6M6,19H4V17H6M12,7V3H2V21H22V7H12Z'
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item.-border:nth-child(5) > a > span.MenuList-Title').text).to eq data[:json]['SideNavigation']['a'][6]

        # MenuList 県公式サイト
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item:nth-child(6) > a > span.MenuList-Title').text).to eq data[:json]['SideNavigation']['a'][7]

        # MenuList 対策本部資料
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item:nth-child(7) > a > span.MenuList-Title').text).to eq data[:json]['SideNavigation']['a'][9]
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item:nth-child(7) > a')[:href]).to eq 'https://www.pref.iwate.jp/kurashikankyou/iryou/kenkou/jouhou/1035134.html'

        # MenuList 当サイトについて
        expect(find('nav.SideNavigation-Menu > ul.MenuList > li.MenuList-Item:nth-child(8) > a > span.MenuList-Title').text).to eq data[:json]['Common']['当サイトについて']

        # MenuList LINE
        expect(find('footer.SideNavigation-Footer > div.SideNavigation-Social > a:nth-child(1)')[:href]).to eq 'https://line.me/R/ti/p/%40566kxdol'
        expect(find('footer.SideNavigation-Footer > div.SideNavigation-Social > a:nth-child(1) > picture > img')[:src]).to match %r{/line.png$}

        # MenuList Twitter
        expect(find('footer.SideNavigation-Footer > div.SideNavigation-Social > a:nth-child(2)')[:href]).to eq 'https://twitter.com/iwatevscovid19'
        expect(find('footer.SideNavigation-Footer > div.SideNavigation-Social > a:nth-child(2) > picture > img')[:src]).to match %r{/twitter.png$}

        # MenuList GitHub
        expect(find('footer.SideNavigation-Footer > div.SideNavigation-Social > a:nth-child(3)')[:href]).to eq 'https://github.com/MeditationDuck/covid19'
        expect(find('footer.SideNavigation-Footer > div.SideNavigation-Social > a:nth-child(3) > picture > img')[:src]).to match %r{/github.png$}
      end

      describe 'ナビゲーション遷移後の画面のタイトル' do
        it '/flow' do
          find('ul.MenuList > li:nth-child(2) > a').click
          sleep 1
          expect(find('h2.pageTitle').text).to eq data[:json]['SideNavigation']['a'][4].to_s
        end

        it '/work' do
          find('ul.MenuList > li:nth-child(5) > a').click
          sleep 1
          expect(find('h2.pageTitle').text).to eq data[:json]['SideNavigation']['a'][6].to_s
        end

        it '/about' do
          find('ul.MenuList > li:nth-child(8) > a').click
          sleep 1
          expect(find('h2.pageTitle').text).to eq data[:json]['Common']['当サイトについて'].to_s
        end
      end
    end
  end
end

require 'spec_helper'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
      render_lazy_contents
    end

    it 'h1/h2' do
      expect(find('#app > div > div.appContainer > div > div > header > h1').text).to eq "#{JA_JSON['Common']['新型コロナウイルス感染症']}\n#{JA_JSON['Common']['対策サイト']}"
      expect(find('#app > div > div.appContainer > main > div > div > div.MainPage > div.Header.mb-3 > div.header > h2').text).to eq "#{JA_JSON['Common']['岩手の最新感染動向']}"
    end

    it '/flow' do
      find('header.SideNavigation-Header > .SideNavigation-OpenIcon').click
      find('ul.MenuList > li:nth-child(2) > a').click
      expect(find('h2.pageTitle').text).to eq '新型コロナウイルス感染症が心配なときに'
    end

    it '/work' do
      find('header.SideNavigation-Header > .SideNavigation-OpenIcon').click
      find('ul.MenuList > li:nth-child(4) > a').click
      expect(find('h2.pageTitle').text).to eq '企業の皆様・はたらく皆様へ'
    end

    it '/about' do
      find('header.SideNavigation-Header > .SideNavigation-OpenIcon').click
      find('ul.MenuList > li:nth-child(7) > a').click
      expect(find('h2.pageTitle').text).to eq '当サイトについて'
    end

  end
end

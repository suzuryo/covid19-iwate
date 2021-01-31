# frozen_string_literal: true

require 'spec_helper'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/]' do
    before do
      visit '/'
      # render_lazy_contents
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

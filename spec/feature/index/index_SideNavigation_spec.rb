# frozen_string_literal: true

require 'spec_helper'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit data[:path]
        render_lazy_contents
      end

      it '/flow' do
        find('header.SideNavigation-Header > .SideNavigation-OpenIcon').click
        find('ul.MenuList > li:nth-child(2) > a').click
        expect(find('h2.pageTitle').text).to eq data[:json]['SideNavigation']['a'][4].to_s
      end

      it '/work' do
        find('header.SideNavigation-Header > .SideNavigation-OpenIcon').click
        find('ul.MenuList > li:nth-child(4) > a').click
        expect(find('h2.pageTitle').text).to eq data[:json]['SideNavigation']['a'][6].to_s
      end

      it '/about' do
        find('header.SideNavigation-Header > .SideNavigation-OpenIcon').click
        find('ul.MenuList > li:nth-child(7) > a').click
        expect(find('h2.pageTitle').text).to eq data[:json]['Common']['当サイトについて'].to_s
      end
    end
  end
end

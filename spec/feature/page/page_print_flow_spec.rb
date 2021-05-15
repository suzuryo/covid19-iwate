# frozen_string_literal: true

require 'spec_helper'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit "#{data[:path]}print/flow/"
      end

      it 'title' do
        expect(title).to eq "#{LOCALES[lang][:json]['SideNavigation']['a'][4]}"
      end

      it 'h1' do
        expect(find('#app > div > div > div.PrintMeta > div.PrintMeta-HeadingWrapper > h1').text).to eq "#{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}\n#{LOCALES[lang][:json]['Common']['対策サイト']}"
      end
    end
  end
end



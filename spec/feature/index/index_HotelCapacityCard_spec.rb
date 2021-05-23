# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/HotelCapacityCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit data[:path]
        render_lazy_contents
        page.scroll_to('#HotelCapacityCard')
      end

      describe '宿泊療養の状況(HotelCapacityCard)' do
        it '項目の値' do
          has_hotel_capacity_card(lang: lang, lang_json: data[:json])
          has_no_breadcrumbs(id: '#HotelCapacityCard')
        end
      end
    end
  end
end

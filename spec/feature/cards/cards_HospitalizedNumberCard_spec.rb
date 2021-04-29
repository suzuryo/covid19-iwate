# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/HospitalizedNumberCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/cards/number-of-hospitalized]' do
    before do
      visit '/cards/number-of-hospitalized'
      render_lazy_contents
      page.scroll_to('#HospitalizedNumberCard')
    end

    describe 'meta' do
      it 'title' do
        expect(title).to eq "#{JA_JSON['HospitalizedNumberCard']['title']} | #{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end
    end

    describe '入院と宿泊療養の推移(HospitalizedNumberCard)' do
      it '項目の値' do
        has_hospitalized_number_card
        has_breadcrumbs(id: '#HospitalizedNumberCard', title: '入院と宿泊療養と調整中の推移')
      end
    end
  end
end

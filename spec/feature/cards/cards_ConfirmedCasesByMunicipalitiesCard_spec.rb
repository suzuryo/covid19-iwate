# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/ConfirmedCasesByMunicipalitiesCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/cards/number-of-confirmed-cases-by-municipalities]' do
    before do
      visit '/cards/number-of-confirmed-cases-by-municipalities'
      render_lazy_contents
      page.scroll_to('#ConfirmedCasesByMunicipalitiesCard')
    end

    describe 'meta' do
      it 'title' do
        expect(title).to eq "#{JA_JSON['ConfirmedCasesByMunicipalitiesCard']['title']} | #{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end
    end

    describe '陽性患者数(市町村別)(ConfirmedCasesByMunicipalitiesCard)' do
      it '項目の値' do
        has_confirmed_cases_by_municipalities_card
        has_breadcrumbs(id: '#ConfirmedCasesByMunicipalitiesCard', title: '陽性患者数（市町村別）')
      end
    end
  end
end

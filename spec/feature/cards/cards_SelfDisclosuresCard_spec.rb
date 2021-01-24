# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/SelfDisclosuresCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/cards/self-disclosures]' do
    before do
      visit '/cards/self-disclosures'
      render_lazy_contents
      page.scroll_to('#SelfDisclosuresCard')
    end

    describe '自主公表(SelfDisclosuresCard)' do
      it '項目の値' do
        has_self_disclosures_card
        has_breadcrumbs(id: '#SelfDisclosuresCard', title: JA_JSON['SelfDisclosures']['a'][0])
      end
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/WhatsNewCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/cards/whats-new]' do
    before do
      visit '/cards/whats-new'
      render_lazy_contents
      page.scroll_to('#WhatsNewCard')
    end

    describe '最新のお知らせ(WhatsNewCard)' do
      it '項目の値' do
        has_whats_new_card
        has_breadcrumbs(id: '#WhatsNewCard', title: JA_JSON['WhatsNew']['title'])
      end
    end
  end
end

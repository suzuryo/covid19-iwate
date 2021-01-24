# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/WhatsNewCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/]' do
    before do
      visit '/'
      page.scroll_to('.v-tabs')
      find('#app .v-tabs .v-slide-group__content a[href="#tab-1"]').click
      render_lazy_contents
    end

    describe '最新のお知らせ(WhatsNewCard)' do
      it '項目の値' do
        has_whats_new_card
        has_no_breadcrumbs(id: '#WhatsNewCard')
      end
    end
  end
end

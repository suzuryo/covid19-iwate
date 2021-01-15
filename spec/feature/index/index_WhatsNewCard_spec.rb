require 'spec_helper'
require_relative '../../lib/WhatsNewCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do
    before do
      visit '/'
      page.scroll_to('.v-tabs')
      find('#app .v-tabs .v-slide-group__content a[href="#tab-1"]').click
      render_lazy_contents
    end

    describe '最新のお知らせ(WhatsNewCard)' do
      it '項目の値' do
        whats_new_card

        # index の card 一覧では breadcrumbs は表示されない
        expect(page).not_to have_selector('#WhatsNewCard nav ul.v-breadcrumbs')
      end
    end
  end
end

require 'spec_helper'
require_relative '../../lib/WhatsNewCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/whats-new]' do
    before do
      visit '/cards/whats-new'
      render_lazy_contents
      page.scroll_to('#WhatsNewCard')
    end

    describe '最新のお知らせ(WhatsNewCard)' do
      it '項目の値' do
        whats_new_card

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#WhatsNewCard nav ul.v-breadcrumbs')
        expect(find('#WhatsNewCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq JA_JSON['Common']['ホーム']
        expect(find('#WhatsNewCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq JA_JSON['WhatsNew']["title"]
      end
    end
  end
end

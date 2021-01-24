require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/UntrackedRateCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/cards/untracked-rate]' do
    before do
      visit '/cards/untracked-rate'
      render_lazy_contents
      page.scroll_to('#UntrackedRateCard')
    end

    describe '接触歴等不明者数(7日間移動平均)(UntrackedRateCard)' do
      it '項目の値' do
        has_untracked_rate_card
        has_breadcrumbs(id: '#UntrackedRateCard', title: '接触歴等不明者数(7日間移動平均)')
      end
    end
  end
end

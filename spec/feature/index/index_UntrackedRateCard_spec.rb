require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/UntrackedRateCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
      render_lazy_contents
      page.scroll_to('#UntrackedRateCard')
    end

    describe '接触歴等不明者数(7日間移動平均)(UntrackedRateCard)' do
      it '項目の値' do
        untracked_rate_card
        has_no_breadcrumbs(id: '#UntrackedRateCard')
      end
    end

  end
end

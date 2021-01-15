require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/SelfDisclosuresCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do
    before do
      visit '/'
      page.scroll_to('.v-tabs')
      find('#app .v-tabs .v-slide-group__content a[href="#tab-1"]').click
      render_lazy_contents
    end

    describe '自主公表(SelfDisclosuresCard)' do
      it '項目の値' do
        has_self_disclosures_card
        has_no_breadcrumbs(id: '#SelfDisclosuresCard')
      end
    end
  end
end

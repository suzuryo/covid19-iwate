require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/ConfirmedCasesDetailsCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
      render_lazy_contents
      page.scroll_to('#ConfirmedCasesDetailsCard')
    end

    describe '検査陽性者の状況(ConfirmedCasesDetailsCard)' do
      it '項目の値' do
        has_confirmed_cases_details_card
        has_no_breadcrumbs(id: '#ConfirmedCasesDetailsCard')
      end
    end

  end
end

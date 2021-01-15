require 'spec_helper'
require_relative '../../lib/MonitoringConfirmedCasesNumberCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
      render_lazy_contents
      page.scroll_to('#MonitoringConfirmedCasesNumberCard')
    end

    describe '新規陽性者数の7日間移動平均(MonitoringConfirmedCasesNumberCard)' do
      it '項目の値' do
        monitoring_confirmed_cases_number_card

        # index の card 一覧では breadcrumbs は表示されない
        expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard nav ul.v-breadcrumbs')
      end
    end

  end
end

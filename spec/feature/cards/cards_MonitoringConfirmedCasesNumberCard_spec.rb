require 'spec_helper'
require_relative '../../lib/MonitoringConfirmedCasesNumberCard'

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/monitoring-number-of-confirmed-cases]' do

    before do
      visit '/cards/monitoring-number-of-confirmed-cases'
      render_lazy_contents
      page.scroll_to('#MonitoringConfirmedCasesNumberCard')
    end

    describe '新規陽性者数の7日間移動平均(MonitoringConfirmedCasesNumberCard)' do
      it '項目の値' do
        monitoring_confirmed_cases_number_card

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard nav ul.v-breadcrumbs')
        expect(find('#MonitoringConfirmedCasesNumberCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq JA_JSON['Common']['ホーム']
        expect(find('#MonitoringConfirmedCasesNumberCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '新規陽性者数の7日間移動平均'
      end
    end

  end
end

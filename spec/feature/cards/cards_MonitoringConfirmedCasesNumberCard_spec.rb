require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/MonitoringConfirmedCasesNumberCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/cards/monitoring-number-of-confirmed-cases]' do
    before do
      visit '/cards/monitoring-number-of-confirmed-cases'
      render_lazy_contents
      page.scroll_to('#MonitoringConfirmedCasesNumberCard')
    end

    describe '新規陽性者数の7日間移動平均(MonitoringConfirmedCasesNumberCard)' do
      it '項目の値' do
        has_monitoring_confirmed_cases_number_card
        has_breadcrumbs(id: '#MonitoringConfirmedCasesNumberCard', title: '新規陽性者数の7日間移動平均')
      end
    end
  end
end

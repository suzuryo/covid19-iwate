# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/WeeklyMapCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit data[:path]
        render_lazy_contents
        page.scroll_to('#WeeklyMapCard')
      end

      describe '直近1週間の陽性例マップ(WeeklyMapCard)' do
        it '項目の値' do
          has_weekly_map_card(lang: lang, lang_json: data[:json])
          has_no_breadcrumbs(id: '#WeeklyMapCard')
        end
      end
    end
  end
end

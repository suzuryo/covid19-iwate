# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/ConfirmedCasesDetailsCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit data[:path]
        render_lazy_contents
        page.scroll_to('.ConfirmedCasesDetailsCard')
      end

      describe '検査陽性者の状況(ConfirmedCasesDetailsCard)' do
        it '項目の値' do
          has_confirmed_cases_details_card(lang: lang, lang_json: data[:json])
          has_no_breadcrumbs(id: '#ConfirmedCasesDetailsCard')
        end
      end
    end
  end
end

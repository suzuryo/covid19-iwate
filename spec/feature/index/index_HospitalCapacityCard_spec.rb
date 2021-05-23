# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/HospitalCapacityCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit data[:path]
        render_lazy_contents
        page.scroll_to('#HospitalCapacityCard')
      end

      describe '入院病床の状況(HospitalCapacityCard)' do
        it '項目の値' do
          has_hospital_capacity_card(lang: lang, lang_json: data[:json])
          has_no_breadcrumbs(id: '#HospitalCapacityCard')
        end
      end
    end
  end
end

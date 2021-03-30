# frozen_string_literal: true

require 'spec_helper'
require 'json'

# sw.js で ServiceWorkerのunregisterをする

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/]' do
    before do
      visit '/sw.js'
    end

    it 'has unregister code' do
      expect(page.html).to have_content('self.registration.unregister()')
    end
  end
end

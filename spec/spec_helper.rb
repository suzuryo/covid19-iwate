# frozen_string_literal: true

require 'active_support/all'
require 'capybara/rspec'
require 'capybara/dsl'
require 'json'
require 'selenium-webdriver'

include ActiveSupport::NumberHelper

Capybara.register_driver :emulated_chrome_ios do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_emulation(device_name: 'iPhone 6/7/8')

  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 options: options)
end

Capybara.default_driver = :emulated_chrome_ios
Capybara.app_host = 'http://localhost:3000'

def render_lazy_contents
  [0, 300, 600, 1200, 2400, 6000, 10_000, 0, 10_000].each do |i|
    sleep 0.1
    page.evaluate_script "window.scroll(0,#{i})"
  end
end

DAILY_POSITIVE_DETAIL_JSON = JSON.parse(File.read(File.join(__dir__, '../data/daily_positive_detail.json')))
DATA_JSON = JSON.parse(File.read(File.join(__dir__, '../data/data.json')))
JA_JSON = JSON.parse(File.read(File.join(__dir__, '../assets/locales/ja.json')))
EN_JSON = JSON.parse(File.read(File.join(__dir__, '../assets/locales/en.json')))
NEWS_JSON = JSON.parse(File.read(File.join(__dir__, '../data/news.json')))
ALERT_JSON = JSON.parse(File.read(File.join(__dir__, '../data/alert.json')))
PATIENT_MUNICIPALITIES_JSON = JSON.parse(File.read(File.join(__dir__, '../data/patient_municipalities.json')))
POSITIVE_RATE_JSON = JSON.parse(File.read(File.join(__dir__, '../data/positive_rate.json')))
POSITIVE_STATUS_JSON = JSON.parse(File.read(File.join(__dir__, '../data/positive_status.json')))
SELF_DISCLOSURES_JSON = JSON.parse(File.read(File.join(__dir__, '../data/self_disclosures.json')))

NEWS_ITEMS = NEWS_JSON['newsItems'].sort_by.with_index { |v, i| [Date.parse(v['date']), i] }.reverse
ALERT_ITEMS = ALERT_JSON['alertItems'].sort_by.with_index { |v, i| [Date.parse(v['date']), i] }.reverse
SELF_DISCLOSURES_ITEMS = SELF_DISCLOSURES_JSON['newsItems'].sort_by.with_index { |v, i| [Date.parse(v['date']), i] }.reverse

LOCALES = {
  ja: {
    path: '/',
    json: JA_JSON
  },
  en: {
    path: '/en/',
    json: EN_JSON
  }
}.freeze

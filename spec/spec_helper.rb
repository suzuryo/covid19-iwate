# frozen_string_literal: true

require 'active_support/all'
require 'capybara/rspec'
require 'capybara/dsl'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'selenium-webdriver'
require 'time'

include ActiveSupport::NumberHelper

Capybara.register_driver :emulated_chrome_ios do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--host-resolver-rules=MAP www.google-analytics.com 127.0.0.1, MAP www.googletagmanager.com 127.0.0.1')
  options.add_emulation(device_name: 'iPhone 6/7/8')

  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 options: options)
end

Capybara.default_driver = :emulated_chrome_ios

### Firefox
# Capybara.register_driver :firefox do |app|
#   browser_options = ::Selenium::WebDriver::Firefox::Options.new()
#   # browser_options.args << '--headless'
#
#   Capybara::Selenium::Driver.new(
#     app,
#     browser: :firefox,
#     options: browser_options
#   )
# end
#
# Capybara.default_driver = :firefox

Capybara.app_host = 'http://localhost:3000'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  # config.default_formatter = 'doc'

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.after do |example|
    if example.exception
      # width = page.evaluate_script("window.innerWidth")
      # height = page.evaluate_script("document.body.scrollHeight")
      # page.driver.browser.manage.window.resize_to(width, height)

      meta = example.metadata
      filename = File.basename(meta[:file_path])
      line_number = meta[:line_number]
      screenshot_name = "#{filename}-#{line_number}-#{Time.now.strftime('%Y%m%d%H%M%S%3N').to_i}.png"
      screenshot_path = "spec/screenshot/#{screenshot_name}"
      page.save_screenshot(screenshot_path)
    end
  end
end

def render_lazy_contents
  # div.v-lazy の中に div.row が2つまたは1つ入って min-height が 550
  # div.rowの数 * 550 までスクロールする
  h = 550
  i = 0
  loop do
    m = page.all('div.v-lazy').count * 2
    i = i > h * m ? 0 : i + h
    c = page.all('div.v-lazy > div.row > div.DataCard').count
    break if [m - 1, m].include?(c)

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
MAIN_SUMMARY_JSON = JSON.parse(File.read(File.join(__dir__, '../data/main_summary.json')))

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

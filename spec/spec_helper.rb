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
  [0, 300, 600, 1200, 2400, 6000, 10000, 0, 10000].each do |i|
    sleep 0.1
    page.evaluate_script "window.scroll(0,#{i})"
  end
end

DATA_JSON = JSON.parse(File.read(File.join(__dir__, '../data/data.json')))
JA_JSON = JSON.parse(File.read(File.join(__dir__, '../assets/locales/ja.json')))

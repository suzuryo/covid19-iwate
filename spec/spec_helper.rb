require 'capybara/rspec'
require 'capybara/dsl'
require 'selenium-webdriver'

Capybara.register_driver :emulated_chrome_ios do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_emulation(device_name: 'iPhone 6/7/8')

  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 options: options)
end

Capybara.default_driver = :emulated_chrome_ios
Capybara.app_host = 'http://localhost:3000'

# Following Redirection
def fetch_url_with_redirect(uri, limit = 10)
  # You should choose a better exception.
  raise ArgumentError, 'too many HTTP redirects' if limit == 0
  response = Net::HTTP.get_response(uri)

  case response
  when Net::HTTPSuccess then
    response
  when Net::HTTPRedirection then
    location = response['location']
    warn "redirected to #{location}"
    fetch_url_with_redirect(URI("#{uri.scheme}://#{uri.hostname}:#{uri.port}#{location}"), limit - 1)
  else
    response.value
  end
end

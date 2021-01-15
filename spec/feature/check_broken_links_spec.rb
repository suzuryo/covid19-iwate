require 'spec_helper'
require 'json'
require 'typhoeus'

# 1. Vue.js を chrome (mobile emulation iPhone 6/7/8) で解釈する
# 2. ページ上の a href を 全部探す
# 3. href を GET してみて、 status code が 200 を確認
# なぜなら、盛岡市の個別事例ページがよく URL が変更になって 404 になるから。

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do
    urls = []

    # data.json の 陽性事例の 個別ページのURL は直接読み込む
    DATA_JSON['patients']['data'].each do |item|
      urls << URI(item['url']) unless item['url'].blank?
    end

    before do
      # chromeで / にアクセスして a タグを全部探す
      visit '/'
      render_lazy_contents
      page.all('a').each do |a|
        urls << URI(a['href'])
      end
    end

    it 'has no broken links' do
      hydra = Typhoeus::Hydra.new(max_concurrency: 10)

      # すべての href に対して
      requests = urls.uniq.map do |url|
        request = Typhoeus::Request.new(url, method: :head, followlocation: true)
        hydra.queue(request)
        request
      end

      hydra.run

      responses = requests.map do |request|
        p "#{request.response.response_code} #{request.response.redirect_count} #{request.base_url}"
        expect(request.response.response_code).to eq 200
      end
    end

  end
end

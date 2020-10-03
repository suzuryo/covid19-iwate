require 'spec_helper'
require 'json'
require 'net/http'

# 1. Vue.js を chrome (mobile emulation iPhone 6/7/8) で解釈する
# 2. ページ上の a href を 全部探す
# 3. href を GET してみて、 status code が 200 を確認
# なぜなら、盛岡市の個別事例ページがよく URL が変更になって 404 になるから。

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do
    urls = []

    # data.json の 陽性事例の 個別ページのURL は直接読み込む
    data_json = JSON.load(File.open(File.join(__dir__, '../../data/data.json')))
    data_json['patients']['data'].each do |item|
      urls << URI(item['url']) unless item['url'].nil?
    end

    before do
      # chromeで / にアクセスして a タグを全部探す
      visit '/'
      page.all('a').each do |a|
        urls << URI(a['href'])
      end
    end

    it 'has no broken links' do
      # すべての href に対して
      urls.uniq.each do |url|
        # redirect をフォローしつつステータスコードを確認
        res = fetch_url_with_redirect(url)
        expect(res.code).to eq '200' # ページが存在している
        p res.code, url.to_s
        sleep 1
      end
    end

  end
end

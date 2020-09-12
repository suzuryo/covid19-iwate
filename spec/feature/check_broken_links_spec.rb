require 'spec_helper'
require 'json'
require 'net/http'

# Vue.js を chrome mobile emulation で解釈した上で、
# ページ上の a href を 全部探して、 href を GET してみて、
# status code が 200 で返ってくることをチェックする。
# なぜなら、盛岡市の個別事例ページがよく URL が変更になって 404 になるから。

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do
    urls = []

    # data.json の 陽性者個別ページのURL は直接読み込む
    data_json = JSON.load(File.open(File.join(__dir__,'../../data/data.json')))
    data_json['patients']['data'].each do |item|
      urls << URI(item['url'])
    end

    before do
      visit '/'
      page.all('a').each do |a|
        urls << URI(a['href'])
      end
    end

    it 'has no broken links' do
      urls.uniq.each do |url|
        p res.code, url.to_s
        res = fetch_url_with_redirect(url)
        expect(res.code).to eq '200'
        sleep 1
      end
    end

  end
end

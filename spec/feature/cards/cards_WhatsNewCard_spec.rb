require 'spec_helper'

ja_json = JSON.parse(File.read(File.join(__dir__, '../../../assets/locales/ja.json')))
news_json = JSON.parse(File.read(File.join(__dir__, '../../../data/news.json')))

# news.json.newsItemsを日付でstable sort(比較結果が同じ要素は元の順序通りに並ぶ)して降順
news_items = news_json['newsItems'].sort_by.with_index { |v, i| [Date.parse(v['date']), i] }.reverse

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/whats-new]' do
    before do
      visit '/cards/whats-new'
      render_lazy_contents
      page.scroll_to('#WhatsNewCard')
    end

    describe '最新のお知らせ(WhatsNewCard)' do
      it '項目の値' do
        # h3
        expect(find('#WhatsNewCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq ja_json['WhatsNew']["title"].to_s

        # テーブルの中身
        news_items.each_with_index do |d, index|
          # テーブルの上からi行目をチェックする(icon + text)
          expect(find("#WhatsNewCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1+index}) > td:nth-child(1)").text).to eq "#{d['icon']} #{d['text']['ja']}"

          # テーブルの上からi行目をチェックする(日付)
          expect(find("#WhatsNewCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1+index}) > td:nth-child(2)").text).to eq "#{Date.parse(d['date']).strftime("%-m月%-d日")}"
        end

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#WhatsNewCard nav ul.v-breadcrumbs')
        expect(find('#WhatsNewCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq ja_json['Common']['ホーム']
        expect(find('#WhatsNewCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq ja_json['WhatsNew']["title"]
      end
    end
  end
end

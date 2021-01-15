require 'spec_helper'

ja_json = JSON.parse(File.read(File.join(__dir__, '../../assets/locales/ja.json')))
news_json = JSON.parse(File.read(File.join(__dir__, '../../data/news.json')))

# news.json.newsItemsを日付でstable sort(比較結果が同じ要素は元の順序通りに並ぶ)して降順
news_items = news_json['newsItems'].sort_by.with_index { |v, i| [Date.parse(v['date']), i] }.reverse

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do
    before do
      visit '/'
      page.scroll_to('.v-tabs')
      find('#app .v-tabs .v-slide-group__content a[href="#tab-1"]').click
      render_lazy_contents
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

        # index の card 一覧では breadcrumbs は表示されない
        expect(page).not_to have_selector('#WhatsNewCard nav ul.v-breadcrumbs')
      end
    end
  end
end

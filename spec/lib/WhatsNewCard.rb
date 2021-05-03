# frozen_string_literal: true

require 'spec_helper'

def has_whats_new_card
  # h3
  expect(find('#WhatsNewCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq JA_JSON['WhatsNewCard']['title'].to_s
  d = find('#WhatsNewCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  expect(URI.parse(d).path).to eq '/cards/whats-new'

  # テーブルの中身
  NEWS_ITEMS.each_with_index do |d, index|
    break if index > 9
    # テーブルの上からi行目をチェックする(icon + text)
    if d['url']['ja'].blank?
      expect(page).not_to have_selector("#WhatsNewCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(1) > a")
      expect(find("#WhatsNewCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(1)").text).to eq (d['text']['ja']).to_s
    else
      expect(find("#WhatsNewCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(1) > a").text).to eq "#{d['icon']} #{d['text']['ja']}"
    end

    # テーブルの上からi行目をチェックする(日付)
    expect(find("#WhatsNewCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(2)").text).to eq Date.parse(d['date']).strftime('%-m月%-d日').to_s

    # 最初は1ページあたり10件なので11番目のtrは無い
    expect(page.all('#WhatsNewCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(11)').empty?).to eq true

    # 項目中
    d = NEWS_ITEMS.size
    expect(find('#WhatsNewCard > div > div > div.DataView-Content > div > div > div.v-data-footer > div.v-data-footer__pagination').text).to eq JA_JSON['DataView_Footer'][1].to_s.gsub('{itemsLength}', d.to_s).gsub('{pageStart}', '1').gsub('{pageStop}', d < 10 ? d.to_s : '10').rstrip

    # １ページあたり10件
    expect(find('#WhatsNewCard > div > div > div.DataView-Content > div > div > div.v-data-footer > div.v-data-footer__select').text).to eq "#{JA_JSON['DataView_Footer'][0]}\n10"
  end
end

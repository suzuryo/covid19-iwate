require 'spec_helper'

def has_whats_new_card
  # h3
  expect(find('#WhatsNewCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq JA_JSON['WhatsNew']["title"].to_s

  # テーブルの中身
  NEWS_ITEMS.each_with_index do |d, index|
    # テーブルの上からi行目をチェックする(icon + text)
    if d['url']['ja'].blank?
      expect(page).not_to have_selector("#WhatsNewCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1+index}) > td:nth-child(1) > a")
      expect(find("#WhatsNewCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1+index}) > td:nth-child(1)").text).to eq "#{d['text']['ja']}"
    else
      expect(find("#WhatsNewCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1+index}) > td:nth-child(1) > a").text).to eq "#{d['icon']} #{d['text']['ja']}"
    end

    # テーブルの上からi行目をチェックする(日付)
    expect(find("#WhatsNewCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1+index}) > td:nth-child(2)").text).to eq "#{Date.parse(d['date']).strftime("%-m月%-d日")}"
  end
end
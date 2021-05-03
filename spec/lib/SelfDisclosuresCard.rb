# frozen_string_literal: true

require 'spec_helper'

def has_self_disclosures_card
  # h3
  expect(find('#SelfDisclosuresCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq JA_JSON['SelfDisclosuresCard']['title'].to_s
  d = find('#SelfDisclosuresCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  expect(URI.parse(d).path).to eq '/cards/self-disclosures'

  # テーブルの中身
  SELF_DISCLOSURES_ITEMS.each_with_index do |d, index|
    break if index > 9
    # テーブルの上から10行目までをチェックする(icon + text)
    if d['url']['ja'].blank?
      expect(page).not_to have_selector("#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(1) > a")
      expect(find("#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(1)").text).to eq (d['text']['ja']).to_s
    else
      expect(find("#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(1) > a").text).to eq "#{d['icon']} #{d['text']['ja']}"
    end

    # テーブルの上からi行目をチェックする(日付)
    expect(find("#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(#{1 + index}) > td:nth-child(2)").text).to eq Date.parse(d['date']).strftime('%-m月%-d日').to_s
  end

  # 情報提供フォームはDataSetPanelの中
  expect(find('#SelfDisclosuresCard > div > div > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > div.DataView-DataSet-DataInfo-SelfDisclosureForm > a').text).to eq '情報提供フォーム'
  expect(find('#SelfDisclosuresCard > div > div > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > div.DataView-DataSet-DataInfo-SelfDisclosureForm > a')[:href]).to eq 'https://forms.gle/JHB4HJ2c4NnPcmy69'

  # 最初は1ページあたり10件なので11番目のtrは無い
  expect(page.all('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div > table > tbody > tr:nth-child(11)').empty?).to eq true

  # 項目中
  d = SELF_DISCLOSURES_ITEMS.size
  expect(find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-footer > div.v-data-footer__pagination').text).to eq JA_JSON['DataView_Footer'][1].to_s.gsub('{itemsLength}', d.to_s).gsub('{pageStart}', '1').gsub('{pageStop}', d < 10 ? d.to_s : '10').rstrip

  # １ページあたり10件
  expect(find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-footer > div.v-data-footer__select').text).to eq "#{JA_JSON['DataView_Footer'][0]}\n10"

  # 次のページ
  find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-footer > div.v-data-footer__icons-after > button').click

  # 次のページの先頭は11番目の要素
  d = "#{SELF_DISCLOSURES_ITEMS[10]['icon']} #{SELF_DISCLOSURES_ITEMS[10]['text']['ja']}"
  expect(find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td.text-start').text).to eq d.to_s

  # さらに次のページ
  find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-footer > div.v-data-footer__icons-after > button').click

  # さらに次のページの先頭は21番目の要素
  d = "#{SELF_DISCLOSURES_ITEMS[20]['icon']} #{SELF_DISCLOSURES_ITEMS[20]['text']['ja']}"
  expect(find('#SelfDisclosuresCard > div > div > div.DataView-Content > div > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td.text-start').text).to eq d.to_s
end

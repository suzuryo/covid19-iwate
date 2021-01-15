require 'spec_helper'

def confirmed_case_attributes_card
  # h3
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Header > div > div > h3').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['title']

  # 陽性者の合計
  d = DATA_JSON['patients']['data'].size
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq "#{d}"

  # 陽性者の合計の日付
  d = Date.parse(DATA_JSON['patients']['data'].last['確定日']).strftime("%-m月%-d日")
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Header > div > div > div > small').text).to eq JA_JSON['Common']['{date}の累計'].gsub('{date}', d)

  # テーブルの上から1行目をチェックする(通番)
  d = "事例#{DATA_JSON['patients']['data'].last['id'].to_s.rjust(4, '0')}"
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > th').text).to eq "#{d}"

  # テーブルのヘッダーをチェックする
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > thead > tr > th:nth-child(1)').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['table']['通番']
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > thead > tr > th:nth-child(2)').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['table']['確定日']
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > thead > tr > th:nth-child(3)').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['table']['発症日']
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > thead > tr > th:nth-child(4)').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['table']['居住地']
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > thead > tr > th:nth-child(5)').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['table']['年代']
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > thead > tr > th:nth-child(6)').text).to eq JA_JSON['ConfirmedCasesAttributesCard']['table']['📺']

  # テーブルの上から1行目をチェックする(url)
  d = DATA_JSON['patients']['data'].last['url']
  if d
    expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > th > a')[:href]).to eq "#{d}"
  end

  # テーブルの上から1行目をチェックする(確定日)
  d = Date.parse(DATA_JSON['patients']['data'].last['確定日']).strftime("%-m月%-d日")
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq "#{d}"

  # テーブルの上から1行目をチェックする(発症日)
  if DATA_JSON['patients']['data'].last&.[]('無症状')
    d = JA_JSON['ConfirmedCasesAttributesCard']['table']['無症状']
  elsif DATA_JSON['patients']['data'].last&.[]('発症日')
    d = "#{(Date.parse(DATA_JSON['patients']['data'].last&.[]('確定日')) - Date.parse(DATA_JSON['patients']['data'].last&.[]('発症日'))).to_i}日前"
  else
    d = JA_JSON['ConfirmedCasesAttributesCard']['table']['不明']
  end
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq "#{d}"

  # テーブルの上から1行目をチェックする(居住地)
  d = DATA_JSON['patients']['data'].last['居住地']
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(4)').text).to eq "#{d}"

  # テーブルの上から1行目をチェックする(年代)
  d = DATA_JSON['patients']['data'].last['年代']
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(5)').text).to eq "#{d}"

  # テーブルの上から1行目をチェックする(📺)
  d = DATA_JSON['patients']['data'].last['会見']
  if d
    expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(6) > a')[:href]).to eq "#{d}"
  end

  # 最初は1ページあたり15件なので16番目のtrは無い
  expect(page.all('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(16)').empty?).to eq true

  # 次のページ
  find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-footer > div.v-data-footer__icons-after > button').click

  # 次のページの先頭は16番目の要素
  d = "事例#{DATA_JSON['patients']['data'][-16]['id'].to_s.rjust(4, '0')}"
  expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > th').text).to eq "#{d}"

  # 注釈を表示ボタンの文言
  expect(find('#ConfirmedCasesAttributesCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq JA_JSON['Common']['注']

  # 注釈を表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#ConfirmedCasesAttributesCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#ConfirmedCasesAttributesCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#ConfirmedCasesAttributesCard .NotesExpansionPanel .v-expansion-panel-content')

  # 注釈の中身をチェック
  JA_JSON['ConfirmedCasesAttributesCard']['notes'].each_with_index do |d, i |
    expect(find("#ConfirmedCasesAttributesCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(#{1+i})").text).to eq d
  end

  # 注釈を表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#ConfirmedCasesAttributesCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#ConfirmedCasesAttributesCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#ConfirmedCasesAttributesCard .NotesExpansionPanel .v-expansion-panel-content')
end

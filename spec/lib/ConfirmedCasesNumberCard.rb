# frozen_string_literal: true

require 'spec_helper'

def has_confirmed_cases_number_card
  # h3
  expect(find('#ConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div > h3').text).to eq '報告日別による陽性者数の推移'
  d = find('#ConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  expect(URI.parse(d).path).to eq '/cards/number-of-confirmed-cases/'

  # 日付
  d = Date.parse(DATA_JSON['patients_summary']['data'].last['日付']).strftime('%-m月%-d日')
  expect(find('#ConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to match "^#{d} 日別値"

  # 陽性者数
  d = number_to_delimited(DATA_JSON['patients_summary']['data'].last['小計'])
  expect(find('#ConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq d.to_s

  # データを表示ボタンの文言
  expect(find('#ConfirmedCasesNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').text).to eq 'データを表示'

  # データを表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#ConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  find('#ConfirmedCasesNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#ConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

  # テーブルの最上部の値(日付)
  d = Date.parse(DATA_JSON['patients_summary']['data'].last['日付']).strftime('%-m月%-d日')
  expect(find('#ConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > th > time').text).to eq d.to_s

  d = Date.parse(DATA_JSON['patients_summary']['data'].last['日付']).strftime('%Y-%m-%d')
  expect(find('#ConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > th > time')['datetime']).to eq d.to_s

  # テーブルの最上部の値(陽性者・日別)
  d = number_to_delimited(DATA_JSON['patients_summary']['data'].last['小計'])
  expect(find('#ConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq d.to_s

  # テーブルの最上部の値(陽性者・累計)
  d = number_to_delimited(DATA_JSON['patients_summary']['data'].reduce(0) { |sum, n| sum + n['小計'].to_i })
  expect(find('#ConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq d.to_s

  # テーブルの最上部の値(陽性者・累計)(idからチェック)
  d = number_to_delimited(DATA_JSON['patients']['data'].last['id'].to_i)
  expect(find('#ConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq d.to_s

  # データを表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#ConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  find('#ConfirmedCasesNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#ConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
end

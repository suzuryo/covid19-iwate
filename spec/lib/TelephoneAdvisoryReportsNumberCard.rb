# frozen_string_literal: true

require 'spec_helper'

def has_telephone_advisory_reports_number_card
  # h3
  expect(find('#TelephoneAdvisoryReportsNumberCard > div > div > div.DataView-Header > div > div > h3').text).to eq JA_JSON['TelephoneAdvisoryReportsNumberCard']['title']
  d = find('#TelephoneAdvisoryReportsNumberCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  expect(URI.parse(d).path).to eq '/cards/number-of-reports-to-covid19-telephone-advisory-center'

  # 日付
  d = Date.parse(DATA_JSON['contacts']['data'].last['日付']).strftime('%-m月%-d日')
  expect(find('#TelephoneAdvisoryReportsNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to match "^#{d} 実績値"

  # 一般相談 受付件数
  d = number_to_delimited(DATA_JSON['contacts']['data'].last['小計'].to_i)
  expect(find('#TelephoneAdvisoryReportsNumberCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq d.to_s

  # データを表示ボタンの文言
  expect(find('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').text).to eq 'データを表示'

  # データを表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  find('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

  # テーブルの上から1行目をチェックする(日付)
  d = Date.parse(DATA_JSON['contacts']['data'].last['日付']).strftime('%-m月%-d日')
  expect(find('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > th').text).to eq d.to_s

  # テーブルの上から1行目をチェックする(一般相談 受付件数・日別)
  d = number_to_delimited(DATA_JSON['contacts']['data'].last['小計'].to_i)
  expect(find('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq d.to_s

  # テーブルの上から1行目をチェックする(一般相談 受付件数・累計)
  d = number_to_delimited(DATA_JSON['contacts']['data'].reduce(0) { |sum, n| sum + n['小計'].to_i })
  expect(find('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq d.to_s

  # データを表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  find('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

  # 注釈を表示ボタンの文言
  expect(find('#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq '注釈'

  # 注釈を表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content')
  sleep 0.5
  find('#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content')

  # 注釈の中身をチェック
  JA_JSON['TelephoneAdvisoryReportsNumberCard']['notes'].each_with_index do |item, i|
    expect(find("#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(#{1 + i})").text).to eq item
  end

  # 注釈を表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content')

  # データを表示と注釈を表示の両方を開く
  expect(page).not_to have_selector('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  expect(page).not_to have_selector('#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel .v-expansion-panel--active')
  find('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  sleep 1
  find('#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  expect(page).to have_selector('#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel .v-expansion-panel--active')
end

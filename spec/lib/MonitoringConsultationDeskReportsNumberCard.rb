# frozen_string_literal: true

require 'spec_helper'

def has_monitoring_consultation_desk_reports_number_card
  # h3
  expect(find('#MonitoringConsultationDeskReportsNumberCard > div > div > div.DataView-Header > div > div > h3').text).to eq JA_JSON['MonitoringConsultationDeskReportsNumberCard']['title']
  d = find('#MonitoringConsultationDeskReportsNumberCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  expect(URI.parse(d).path).to eq '/cards/monitoring-number-of-reports-to-covid19-consultation-desk'

  # 日付
  d = Date.parse(DATA_JSON['querents']['data'].last['日付']).strftime('%-m月%-d日')
  expect(find('#MonitoringConsultationDeskReportsNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to match "^#{d} 実績値"

  # 受診・相談センター受付件数
  d = number_to_delimited(DATA_JSON['querents']['data'].last['小計'].to_i)
  expect(find('#MonitoringConsultationDeskReportsNumberCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq d.to_s

  # データを表示ボタンの文言
  expect(find('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').text).to eq 'データを表示'

  # データを表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  find('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

  # テーブルの上から1行目をチェックする(日付)
  d = Date.parse(DATA_JSON['querents']['data'].last['日付']).strftime('%-m月%-d日')
  expect(find('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > th').text).to eq d.to_s

  # テーブルの上から1行目をチェックする(受診・相談センター受付件数・日別)
  d = number_to_delimited(DATA_JSON['querents']['data'].last['小計'].to_i)
  expect(find('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq d.to_s

  # テーブルの上から1行目をチェックする(受診・相談センター受付件数・累計)
  d = number_to_delimited(DATA_JSON['querents']['data'].reduce(0) { |sum, n| sum + n['小計'].to_i })
  expect(find('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq d.to_s

  # データを表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  find('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

  # 注釈を表示ボタンの文言
  expect(find('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq '注釈'

  # 注釈を表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content')
  sleep 0.5
  find('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content')

  # 注釈の中身をチェック
  JA_JSON['MonitoringConsultationDeskReportsNumberCard']['notes'].each_with_index do |item, i|
    expect(find("#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(#{1 + i})").text).to eq item
  end

  # 注釈を表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content')

  # データを表示と注釈を表示の両方を開く
  expect(page).not_to have_selector('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  expect(page).not_to have_selector('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel .v-expansion-panel--active')
  find('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
  sleep 1
  find('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#MonitoringConsultationDeskReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
  expect(page).to have_selector('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel .v-expansion-panel--active')
end

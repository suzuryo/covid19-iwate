# frozen_string_literal: true

require 'spec_helper'

def has_monitoring_consultation_desk_reports_number_card
  # h3
  expect(find('#MonitoringConsultationDeskReportsNumberCard > div > div > div.DataView-Header > div > div > h3').text).to eq '受診・相談センター 受付件数'

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
  expect(find('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(1)').text).to eq '2021年2月4日を最後に岩手県がこのデータの公表を止めたため、このグラフの更新が止まっている'
  expect(find('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(2)').text).to eq '主に「症状がある方からの受診等に関する相談」を計上'
  expect(find('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(3)').text).to eq 'コールセンター・各保健所等への受付件数の合計'
  expect(find('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(4)').text).to eq '窓口を開設した2020年2月8日からのデータを表示'
  expect(find('#MonitoringConsultationDeskReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(5)').text).to eq '岩手県の発表漏れによりデータの存在しない日がある'

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

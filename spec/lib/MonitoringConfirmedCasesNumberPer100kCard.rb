# frozen_string_literal: true

require 'spec_helper'

def has_monitoring_confirmed_cases_number_per_100k_card(lang:, lang_json:)
  # h3
  expect(find('#MonitoringConfirmedCasesNumberPer100kCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq lang_json['MonitoringConfirmedCasesNumberPer100kCard']['title'].to_s
  d = find('#MonitoringConfirmedCasesNumberPer100kCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/monitoring-number-of-confirmed-cases-per-100k/"

  # DataSet
  # 中部保健所管内の直近1週間対人口10万人あたりを算出
  d = DATA_JSON['patients']['data'].filter{|i| ['中部保健所管内', '花巻市', '遠野市', '北上市', '西和賀町'].include?i['居住地']}.filter{|i| Time.parse(i['確定日']) > Time.parse(POSITIVE_RATE_JSON['data'].last['diagnosed_date']).days_ago(7)}.size * 100000.0 / 216841
  d = number_to_delimited(page.evaluate_script("#{d}.toFixed(1)"))
  expect(find('#MonitoringConfirmedCasesNumberPer100kCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > strong').text).to eq d
  expect(find('#MonitoringConfirmedCasesNumberPer100kCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span > small').text).to eq lang_json['Common']['人'].gsub(' ', '')

  # 注釈を表示ボタンの文言
  expect(find('#MonitoringConfirmedCasesNumberPer100kCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq lang_json['Common']['注']

  # 注釈を表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberPer100kCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#MonitoringConfirmedCasesNumberPer100kCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#MonitoringConfirmedCasesNumberPer100kCard .NotesExpansionPanel .v-expansion-panel-content')

  # 注釈の中身をチェック
  lang_json['MonitoringConfirmedCasesNumberPer100kCard']['notes'].each_with_index do |item, i|
    expect(find("#MonitoringConfirmedCasesNumberPer100kCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(#{1 + i})").text).to eq item
  end

  # 注釈を表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#MonitoringConfirmedCasesNumberPer100kCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#MonitoringConfirmedCasesNumberPer100kCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberPer100kCard .NotesExpansionPanel .v-expansion-panel-content')
end

# frozen_string_literal: true

require 'spec_helper'

def has_confirmed_cases_by_municipalities_card(lang:, lang_json:)
  # h3
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Header > div > div > h3').text).to eq lang_json['ConfirmedCasesByMunicipalitiesCard']['title']
  d = find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/number-of-confirmed-cases-by-municipalities"

  # 日付
  d = if lang == :ja
        Date.parse(PATIENT_MUNICIPALITIES_JSON['date']).strftime('%-m月%-d日')
      elsif lang == :en
        Date.parse(PATIENT_MUNICIPALITIES_JSON['date']).strftime('%b %-d')
      end
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Header > div > div > div > small').text).to eq lang_json['Common']['{date}の累計'].gsub('{date}', d).gsub(/^ /, '')

  # テーブルの上から1行目をチェックする(市町村)
  d = PATIENT_MUNICIPALITIES_JSON['datasets']['data'].first['label']
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(1) > td:nth-child(1)').text).to eq lang_json[d]

  # テーブルの上から1行目をチェックする(陽性者数)
  d = number_to_delimited(PATIENT_MUNICIPALITIES_JSON['datasets']['data'].first['count'])
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq d.to_s

  # テーブルの上から1行目をチェックする(対人口)
  d = "#{PATIENT_MUNICIPALITIES_JSON['datasets']['data'].first['count_per_population']}%"
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq d

  # テーブルの上から1行目をチェックする(直近1週間)
  d = number_to_delimited(
    DATA_JSON['patients']['data']
      .select { | item | item['居住地'] == PATIENT_MUNICIPALITIES_JSON['datasets']['data'].first['label'] }
      .select { |item| Date.parse(item['確定日']) > Date.parse(DATA_JSON['patients_summary']['data'].last['日付']) - 8 }
      .count
  )
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(1) > td:nth-child(4)').text).to eq d.to_s

  # テーブルの上から1行目をチェックする(直近1週間対人口10万人)
  d = DATA_JSON['patients']['data']
        .select { | item | item['居住地'] == PATIENT_MUNICIPALITIES_JSON['datasets']['data'].first['label'] }
        .select { |item| Date.parse(item['確定日']) > Date.parse(DATA_JSON['patients_summary']['data'].last['日付']) - 8 }
        .count * 100000.0 / 291320.0 # 盛岡市の場合
  d = page.evaluate_script("#{d}.toFixed(1)")
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(1) > td:nth-child(5)').text).to eq d.to_s

  # 市町村を1回目クリックしても、一番下は常に「県外」
  find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(1)').click
  expect(page).to have_selector '#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(1).text-start.sortable.active.asc'
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(34) > td:nth-child(1)').text).to eq lang_json['県外']

  # 市町村を2回目クリックしても、一番下は常に「県外」
  find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(1)').click
  expect(page).to have_selector '#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(1).text-start.sortable.active.desc'
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(34) > td:nth-child(1)').text).to eq lang_json['県外']

  # 市町村を3回目クリックしても、一番下は常に「県外」
  find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(1)').click
  expect(page).not_to have_selector '#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(1).text-start.sortable.active'
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(34) > td:nth-child(1)').text).to eq lang_json['県外']

  # 陽性者数を1回目クリックしたら昇順に並んでいる。県外は常に一番下
  find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(2)').click
  expect(page).to have_selector '#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(2).text-end.sortable.active.asc'
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(34) > td:nth-child(1)').text).to eq lang_json['県外']
  32.times do |i|
    a = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 1}) > td:nth-child(2)").text
    b = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 2}) > td:nth-child(2)").text
    expect(a.to_i <= b.to_i).to be true
  end

  # 陽性者数を2回目クリックしたら降順に並んでいる。県外は常に一番下
  find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(2)').click
  expect(page).to have_selector '#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(2).text-end.sortable.active.desc'
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(34) > td:nth-child(1)').text).to eq lang_json['県外']
  32.times do |i|
    a = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 1}) > td:nth-child(2)").text
    b = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 2}) > td:nth-child(2)").text
    expect(a.to_i >= b.to_i).to be true
  end

  # 対人口を1回目クリックしたら昇順に並んでいる。県外は常に一番下
  find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(3)').click
  expect(page).to have_selector '#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(3).text-end.sortable.active.asc'
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(34) > td:nth-child(1)').text).to eq lang_json['県外']
  32.times do |i|
    a = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 1}) > td:nth-child(3)").text.gsub('%', '')
    b = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 2}) > td:nth-child(3)").text.gsub('%', '')
    expect(a.to_f <= b.to_f).to be true
  end

  # 対人口を2回目クリックしたら降順に並んでいる。県外は常に一番下
  find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(3)').click
  expect(page).to have_selector '#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(3).text-end.sortable.active.desc'
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(34) > td:nth-child(1)').text).to eq lang_json['県外']
  32.times do |i|
    a = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 1}) > td:nth-child(3)").text.gsub('%', '')
    b = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 2}) > td:nth-child(3)").text.gsub('%', '')
    expect(a.to_f >= b.to_f).to be true
  end

  # 直近1週間を1回目クリックしたら昇順に並んでいる。県外は常に一番下
  find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(4)').click
  expect(page).to have_selector '#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(4).text-end.sortable.active.asc'
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(34) > td:nth-child(1)').text).to eq lang_json['県外']
  32.times do |i|
    a = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 1}) > td:nth-child(4)").text
    b = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 2}) > td:nth-child(4)").text
    expect(a.to_i <= b.to_i).to be true
  end

  # 直近1週間を2回目クリックしたら降順に並んでいる。県外は常に一番下
  find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(4)').click
  expect(page).to have_selector '#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(4).text-end.sortable.active.desc'
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(34) > td:nth-child(1)').text).to eq lang_json['県外']
  32.times do |i|
    a = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 1}) > td:nth-child(4)").text
    b = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 2}) > td:nth-child(4)").text
    expect(a.to_i >= b.to_i).to be true
  end

  # 直近1週間対人口10万人を1回目クリックしたら昇順に並んでいる。県外は常に一番下
  find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(5)').click
  expect(page).to have_selector '#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(5).text-end.sortable.active.asc'
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(34) > td:nth-child(1)').text).to eq lang_json['県外']
  32.times do |i|
    a = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 1}) > td:nth-child(5)").text
    b = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 2}) > td:nth-child(5)").text
    expect(a.to_f <= b.to_f).to be true
  end

  # 直近1週間対人口10万人を2回目クリックしたら昇順に並んでいる。県外は常に一番下
  find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(5)').click
  expect(page).to have_selector '#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(5).text-end.sortable.active.desc'
  expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(34) > td:nth-child(1)').text).to eq lang_json['県外']
  32.times do |i|
    a = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 1}) > td:nth-child(5)").text
    b = find("#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(#{i + 2}) > td:nth-child(5)").text
    expect(a.to_f >= b.to_f).to be true
  end

  # 注釈を表示ボタンの文言
  expect(find('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq lang_json['Common']['注']

  # 注釈を表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content')

  # 注釈の中身をチェック
  lang_json['ConfirmedCasesByMunicipalitiesCard']['notes'].each_with_index do |item, index|
    expect(find("#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(#{index + 1})").text).to eq item
  end

  # 注釈を表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content')
end

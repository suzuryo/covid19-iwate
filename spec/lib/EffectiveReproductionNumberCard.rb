# frozen_string_literal: true

require 'spec_helper'

def has_effective_reproduction_number_card(lang:, lang_json:)
  # h3
  expect(find('#EffectiveReproductionNumberCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq lang_json['EffectiveReproductionNumberCard']['title'].to_s
  d = find('#EffectiveReproductionNumberCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/effective-reproduction-number/"

  # DataSet
  # 岩手県全域の実効再生産数を計算
  m1sum = DATA_JSON['patients']['data'].filter{|i| Time.parse(i['確定日']) > Time.parse(POSITIVE_RATE_JSON['data'].last['diagnosed_date']).days_ago(7)}.size
  m2sum = DATA_JSON['patients']['data'].filter{|i| Time.parse(i['確定日']) < Time.parse(POSITIVE_RATE_JSON['data'].last['diagnosed_date']).days_ago(4) && Time.parse(i['確定日']) > Time.parse(POSITIVE_RATE_JSON['data'].last['diagnosed_date']).days_ago(12)}.size
  d = m1sum.to_f / m2sum.to_f
  d = number_to_delimited(page.evaluate_script("#{d}.toFixed(1)"))
  expect(find('#EffectiveReproductionNumberCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > strong').text).to eq d
  expect(find('#EffectiveReproductionNumberCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span > small').text).to eq ''

  # 注釈を表示ボタンの文言
  expect(find('#EffectiveReproductionNumberCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq lang_json['Common']['注']

  # 注釈を表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#EffectiveReproductionNumberCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#EffectiveReproductionNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#EffectiveReproductionNumberCard .NotesExpansionPanel .v-expansion-panel-content')

  # 注釈の中身をチェック
  lang_json['EffectiveReproductionNumberCard']['notes'].each_with_index do |item, i|
    expect(find("#EffectiveReproductionNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(#{2 + i})").text).to eq item
  end

  # 注釈を表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#EffectiveReproductionNumberCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#EffectiveReproductionNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#EffectiveReproductionNumberCard .NotesExpansionPanel .v-expansion-panel-content')
end

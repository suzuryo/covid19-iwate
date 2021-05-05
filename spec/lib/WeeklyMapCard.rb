# frozen_string_literal: true

require 'spec_helper'

def has_weekly_map_card(lang:, lang_json:)
  # h3
  expect(find('#WeeklyMapCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq lang_json['WeeklyMapCard']['title'].to_s
  d = find('#WeeklyMapCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/weekly-map"

  # div id="weekly_map_canvas"
  expect(page).to have_selector'#WeeklyMapCard > div > div > div.DataView-Content > div#weekly_map_canvas', count: 1
  expect(page).to have_selector'svg#weekly_map', count: 1


  # DataSetPanelの初期状態は岩手県全域の状況
  expect(find('#WeeklyMapCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > span.lTextBefore').text).to eq lang_json['岩手県全域']
  # 直近1週間の養成者数
  d = DATA_JSON['patients']['data'].filter{|i| Time.parse(i['確定日']) > Time.parse(DATA_JSON['patients']['data'].last['確定日']).days_ago(7)}.size
  expect(find('#WeeklyMapCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > strong').text).to eq d.to_s
  expect(find('#WeeklyMapCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > small.DataView-DataSet-DataInfo-summary-unit').text).to eq lang_json['例']
  expect(find('#WeeklyMapCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > small.DataView-DataSet-DataInfo-date').text).to eq lang_json['居住地が県外で県内滞在も含む']

  # 一関と奥州を入れると、Chromeだと  Selenium::WebDriver::Error::ElementClickInterceptedError が発生 (原因不明)
  # 一関と奥州を入れても、Firefoxだと テストが通る
  cities = [
    # data-name | data-area | data-code
    %w[盛岡市 盛岡市保健所管内 03201],
    %w[宮古市 宮古保健所管内 03202],
    %w[大船渡市 大船渡保健所管内 03203],
    %w[花巻市 中部保健所管内 03205],
    %w[北上市 中部保健所管内 03206],
    %w[久慈市 久慈保健所管内 03207],
    %w[遠野市 中部保健所管内 03208],
    # %w[一関市 一関保健所管内 03209],
    %w[陸前高田市 大船渡保健所管内 03210],
    %w[釜石市 釜石保健所管内 03211],
    %w[二戸市 二戸保健所管内 03213],
    %w[八幡平市 県央保健所管内 03214],
    # %w[奥州市 奥州保健所管内 03215],
    %w[滝沢市 県央保健所管内 03216],
    %w[雫石町 県央保健所管内 03301],
    %w[葛巻町 県央保健所管内 03302],
    %w[岩手町 県央保健所管内 03303],
    %w[紫波町 県央保健所管内 03321],
    %w[矢巾町 県央保健所管内 03322],
    %w[西和賀町 中部保健所管内 03366],
    %w[金ケ崎町 奥州保健所管内 03381],
    %w[平泉町 一関保健所管内 03402],
    %w[住田町 大船渡保健所管内 03441],
    %w[大槌町 釜石保健所管内 03461],
    %w[山田町 宮古保健所管内 03482],
    %w[岩泉町 宮古保健所管内 03483],
    %w[田野畑村 宮古保健所管内 03484],
    %w[普代村 久慈保健所管内 03485],
    %w[軽米町 二戸保健所管内 03501],
    %w[野田村 久慈保健所管内 03503],
    %w[九戸村 二戸保健所管内 03506],
    %w[洋野町 久慈保健所管内 03507],
    %w[一戸町 二戸保健所管内 03524]
  ]

  # 手元では全市町村のテストが通っているが、通常は一つだけ選んでテストする
  cities = [cities.sample]

  cities.each do |city|
    svg_g_element = find("svg#weekly_map > g[data-name=\"#{city[0]}\"]")
    expect(svg_g_element['data-area']).to eq city[1]
    expect(svg_g_element['data-code']).to eq city[2]
    svg_g_path_element = find("svg#weekly_map > g[data-name=\"#{city[0]}\"] path")

    # 市町村のpathの初期
    expect(svg_g_path_element['stroke-width']).to eq '1px'
    expect(svg_g_path_element['stroke']).to eq '#aaa'

    # 各市をクリックすると
    svg_g_path_element.click

    # 市町村のpathのクリック後
    expect(svg_g_path_element['stroke-width']).to eq '2px'
    expect(svg_g_path_element['stroke']).to eq '#999'

    # DataSetPanelの値が変わる
    expect(find('#WeeklyMapCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > span.lTextBefore').text).to eq lang_json[city[0]]
    # 直近1週間の陽性者数
    d = DATA_JSON['patients']['data'].filter{|i| i['居住地'] == city[0] || i['居住地'] == city[1]}.filter{|i| Time.parse(i['確定日']) > Time.parse(DATA_JSON['patients']['data'].last['確定日']).days_ago(7)}.size
    expect(find('#WeeklyMapCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > strong').text).to eq d.to_s
    expect(find('#WeeklyMapCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > span.DataView-DataSet-DataInfo-summary > small.DataView-DataSet-DataInfo-summary-unit').text).to eq lang_json['例']
    expect(find('#WeeklyMapCard > div.DataView > div.DataView-Inner > div.DataView-Header > div.DataView-DataSetPanel > div.DataView-DataSet > div.DataView-DataSet-DataInfo > small.DataView-DataSet-DataInfo-date').text).to eq "#{lang_json[city[1]]}#{lang_json['{area}を含む'].gsub('{area}', '')}"
  end

  # 注釈を表示ボタンの文言
  expect(find('#WeeklyMapCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq lang_json['Common']['注']

  # 注釈を表示ボタンをクリックすると開く
  expect(page).not_to have_selector('#WeeklyMapCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#WeeklyMapCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).to have_selector('#WeeklyMapCard .NotesExpansionPanel .v-expansion-panel-content')

  # 注釈の中身をチェック
  lang_json['WeeklyMapCard']['notes'].each_with_index do |item, i|
    expect(find("#WeeklyMapCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(#{1 + i})").text).to eq item
  end

  # 注釈を表示ボタンをクリックすると閉じる
  expect(page).to have_selector('#WeeklyMapCard .NotesExpansionPanel .v-expansion-panel-content')
  find('#WeeklyMapCard .NotesExpansionPanel button.v-expansion-panel-header').click
  expect(page).not_to have_selector('#WeeklyMapCard .NotesExpansionPanel .v-expansion-panel-content')
end

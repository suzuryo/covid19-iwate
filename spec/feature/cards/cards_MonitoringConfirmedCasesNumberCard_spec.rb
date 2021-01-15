require 'spec_helper'

data_json = JSON.parse(File.read(File.join(__dir__, '../../../data/data.json')))
positive_rate_json = JSON.parse(File.read(File.join(__dir__, '../../../data/positive_rate.json')))
ja_json = JSON.parse(File.read(File.join(__dir__, '../../../assets/locales/ja.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/monitoring-number-of-confirmed-cases]' do

    before do
      visit '/cards/monitoring-number-of-confirmed-cases'
      render_lazy_contents
      page.scroll_to('#MonitoringConfirmedCasesNumberCard')
    end

    describe '新規陽性者数の7日間移動平均(MonitoringConfirmedCasesNumberCard)' do
      it '項目の値' do
        # h3
        expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq '新規陽性者数の7日間移動平均'
        expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div:nth-child(2) > h3').text).to eq '直近1週間の新規患者数（対人口10万人）'

        # 日付
        d = Date.parse(positive_rate_json['data'].last['diagnosed_date']).strftime("%-m月%-d日")
        expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to match "^#{d} の数値"

        # 新規陽性者数の7日間移動平均
        d = number_to_delimited((data_json['patients_summary']['data'][-7..-1].reduce(0){|sum, n| sum + n['小計'].to_i} / 7.0).round(1))
        expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div:nth-child(1) > div > span > strong').text).to eq "#{d}"

        # 直近1週間の新規患者数（対人口10万人）
        d = number_to_delimited((data_json['patients_summary']['data'][-7..-1].reduce(0){|sum, n| sum + n['小計'].to_i} * 100000.0 / 1212201.0).round(1))
        expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div:nth-child(2) > div > span > strong').text).to eq "#{d}"

        # データを表示ボタンの文言
        expect(find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').text).to eq 'データを表示'

        # データを表示ボタンをクリックすると開く
        expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

        # テーブルの上から2番目の値を確認(日付)
        d = Date.parse(positive_rate_json['data'][-2]['diagnosed_date']).strftime("%-m月%-d日")
        expect(find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(2) > th').text).to eq "#{d}"

        # テーブルの上から2番目の値を確認(陽性者数)
        d = number_to_delimited(positive_rate_json['data'][-2]['positive_count'].to_i)
        expect(find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(2) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から2番目の値を確認(7日間移動平均)
        d = number_to_delimited((positive_rate_json['data'][-8..-2].reduce(0){|sum, n| sum + n['positive_count'].to_i} / 7.0).round(1))
        expect(find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(2) > td:nth-child(3)').text).to eq "#{d}"

        # データを表示ボタンをクリックすると閉じる
        expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

        # 注釈を表示ボタンの文言
        expect(find('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq '注釈'

        # 注釈を表示ボタンをクリックすると開く
        expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content')
        sleep 0.5
        find('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content')

        # 注釈の中身をチェック
        expect(find('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(1)').text).to eq ja_json['Common']['検査結果の判明日を基準とする']
        ja_json['ConfirmedCasesNumberCard']['a'].each_with_index do |d, i|
          expect(find("#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(#{2+i})").text).to eq d
        end
        expect(find('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(3)').text).to eq ja_json['Common']['7MA']

        ja_json['ConfirmedCasesNumberCard']['b'].each_with_index do |d, i |
          expect(find("#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content div[class^=newScenarioSummarry] > p:nth-child(#{1+i})").text).to eq d
        end
        expect(find("#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content div[class^=newScenarioExternalLink] div:nth-child(1) a").text).to eq ja_json['ExtLink']['岩手県17_2']['text']
        expect(find("#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content div[class^=newScenarioExternalLink] div:nth-child(2) a").text).to eq ja_json['ExtLink']['厚生労働省x696']['text']

        # 注釈を表示ボタンをクリックすると閉じる
        expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content')
        find('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel-content')

        # データを表示と注釈を表示の両方を開く
        expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        expect(page).not_to have_selector('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel--active')
        find('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        sleep 1
        find('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard .NotesExpansionPanel .v-expansion-panel--active')

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#MonitoringConfirmedCasesNumberCard nav ul.v-breadcrumbs')
        expect(find('#MonitoringConfirmedCasesNumberCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq ja_json['Common']['ホーム']
        expect(find('#MonitoringConfirmedCasesNumberCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '新規陽性者数の7日間移動平均'
      end
    end

  end
end

require 'spec_helper'

data_json = JSON.parse(File.read(File.join(__dir__, '../../data/data.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
    end

    describe '一般相談 受付件数(TelephoneAdvisoryReportsNumberCard)' do
      it '項目の値' do
        # h3
        expect(find('#TelephoneAdvisoryReportsNumberCard > div > div > div.DataView-Header > div > div > h3').text).to eq '一般相談 受付件数'

        # 日付
        d = Date.parse(data_json['contacts']['data'].last['日付']).strftime("%-m月%-d日")
        expect(find('#TelephoneAdvisoryReportsNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to match "^#{d} 実績値"

        # 一般相談 受付件数
        d = number_to_delimited(data_json['contacts']['data'].last['小計'].to_i)
        expect(find('#TelephoneAdvisoryReportsNumberCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq "#{d}"

        # データを表示ボタンの文言
        expect(find('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').text).to eq 'データを表示'

        # データを表示ボタンをクリックすると開く
        expect(page).not_to have_selector('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        find('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

        # テーブルの上から1行目をチェックする(日付)
        d = Date.parse(data_json['contacts']['data'].last['日付']).strftime("%-m月%-d日")
        expect(find('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > th').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(一般相談 受付件数・日別)
        d = number_to_delimited(data_json['contacts']['data'].last['小計'].to_i)
        expect(find('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(一般相談 受付件数・累計)
        d = number_to_delimited(data_json['contacts']['data'].reduce(0){|sum, n| sum + n['小計'].to_i})
        expect(find('#TelephoneAdvisoryReportsNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq "#{d}"

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
        expect(find("#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(1)").text).to eq '「新型コロナウイルス感染症に関する疑問や心配事がある方からの一般相談」を計上'
        expect(find("#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(2)").text).to eq 'コールセンター・各保健所等への受付件数の合計'
        expect(find("#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(3)").text).to eq '窓口を開設した2020年1月21日からのデータを表示'
        expect(find("#TelephoneAdvisoryReportsNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(4)").text).to eq '岩手県の発表漏れによりデータの存在しない日がある'

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
    end

  end
end

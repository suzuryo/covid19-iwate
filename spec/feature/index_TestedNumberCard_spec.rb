require 'spec_helper'

positive_rate_json = JSON.parse(File.read(File.join(__dir__, '../../data/positive_rate.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
    end

    describe '検査実施件数(TestedNumberCard)' do
      it '項目の値' do
        # h3
        expect(find('#TestedNumberCard > div > div > div.DataView-Header > div > div > h3').text).to eq '検査実施件数'

        # 日付
        d = Date.parse(positive_rate_json['data'].last['diagnosed_date']).strftime("%-m月%-d日")
        expect(find('#TestedNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to eq "#{d}の合計"

        # 検査実施件数
        d = number_to_delimited(positive_rate_json['data'].last['pcr_positive_count'].to_i + positive_rate_json['data'].last['antigen_positive_count'].to_i + positive_rate_json['data'].last['pcr_negative_count'].to_i + positive_rate_json['data'].last['antigen_negative_count'].to_i)
        expect(find('#TestedNumberCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq "#{d}"

        # データを表示ボタンの文言
        expect(find('#TestedNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').text).to eq 'データを表示'

        # データを表示ボタンをクリックすると開く
        expect(page).not_to have_selector('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        find('#TestedNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

        # テーブルの上から2行目をチェックする(日付)
        d = Date.parse(positive_rate_json['data'].last['diagnosed_date']).strftime("%-m月%-d日")
        expect(find('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > th').text).to eq "#{d}"

        # テーブルの上から2行目をチェックする(PCR検査実施件数・日別)
        d = number_to_delimited(positive_rate_json['data'].last['pcr_positive_count'].to_i + positive_rate_json['data'].last['pcr_negative_count'].to_i)
        expect(find('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から2行目をチェックする(PCR検査実施件数・累計)
        d = number_to_delimited(positive_rate_json['data'].reduce(0){|sum, n| sum + n['pcr_positive_count'].to_i + + n['pcr_negative_count'].to_i})
        expect(find('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq "#{d}"

        # テーブルの上から2行目をチェックする(抗原検査実施件数・日別)
        d = number_to_delimited(positive_rate_json['data'].last['antigen_positive_count'].to_i + positive_rate_json['data'].last['antigen_negative_count'].to_i)
        expect(find('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(4)').text).to eq "#{d}"

        # テーブルの上から2行目をチェックする(抗原検査実施件数・累計)
        d = number_to_delimited(positive_rate_json['data'].reduce(0){|sum, n| sum + n['antigen_positive_count'].to_i + + n['antigen_negative_count'].to_i})
        expect(find('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(5)').text).to eq "#{d}"

        # データを表示ボタンをクリックすると閉じる
        expect(page).to have_selector('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        find('#TestedNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        expect(page).not_to have_selector('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

        # 注釈を表示ボタンの文言
        expect(find('#TestedNumberCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq '注釈'

        # 注釈を表示ボタンをクリックすると開く
        expect(page).not_to have_selector('#TestedNumberCard .NotesExpansionPanel .v-expansion-panel-content')
        sleep 0.5
        find('#TestedNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#TestedNumberCard .NotesExpansionPanel .v-expansion-panel-content')

        # 注釈の中身をチェック
        expect(find("#TestedNumberCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(1)").text).to eq '速報値として公開するものであり、後日確定データとして修正される場合がある'

        # 注釈を表示ボタンをクリックすると閉じる
        expect(page).to have_selector('#TestedNumberCard .NotesExpansionPanel .v-expansion-panel-content')
        find('#TestedNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).not_to have_selector('#TestedNumberCard .NotesExpansionPanel .v-expansion-panel-content')

        # データを表示と注釈を表示の両方を開く
        expect(page).not_to have_selector('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        expect(page).not_to have_selector('#TestedNumberCard .NotesExpansionPanel .v-expansion-panel--active')
        find('#TestedNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        sleep 1
        find('#TestedNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#TestedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        expect(page).to have_selector('#TestedNumberCard .NotesExpansionPanel .v-expansion-panel--active')
      end
    end

  end
end

require 'spec_helper'

positive_status_json = JSON.parse(File.read(File.join(__dir__, '../../data/positive_status.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
    end

    describe '入院と宿泊療養の推移(HospitalizedNumberCard)' do
      it '項目の値' do
        # h3
        expect(find('#HospitalizedNumberCard > div > div > div.DataView-Header > div > div > h3').text).to eq '入院と宿泊療養の推移'

        # 入院と宿泊療養の合計
        d = number_to_delimited(positive_status_json['data'].last['hospital'].to_i + positive_status_json['data'].last['hotel'].to_i)
        expect(find('#HospitalizedNumberCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq "#{d}"

        # 入院と宿泊療養の日付
        d = Date.parse(positive_status_json['data'].last['date']).strftime("%-m月%-d日")
        expect(find('#HospitalizedNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to eq "#{d}の合計"

        # データを表示ボタンの文言
        expect(find('#HospitalizedNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').text).to eq 'データを表示'

        # データを表示ボタンをクリックすると開く
        expect(page).not_to have_selector('#HospitalizedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        find('#HospitalizedNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#HospitalizedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

        # テーブルの上から1行目をチェックする(日付)
        d = Date.parse(positive_status_json['data'].last['date']).strftime("%-m月%-d日")
        expect(find('#HospitalizedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > th').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(入院)
        d = number_to_delimited(positive_status_json['data'].last['hospital'].to_i)
        expect(find('#HospitalizedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(宿泊療養)
        d = number_to_delimited(positive_status_json['data'].last['hotel'].to_i)
        expect(find('#HospitalizedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(計)
        d = number_to_delimited(positive_status_json['data'].last['hospitalized'].to_i)
        expect(find('#HospitalizedNumberCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(1) > td:nth-child(4)').text).to eq "#{d}"

        # データを表示ボタンをクリックすると閉じる
        expect(page).to have_selector('#HospitalizedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        find('#HospitalizedNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        expect(page).not_to have_selector('#HospitalizedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')

        # 注釈を表示ボタンの文言
        expect(find('#HospitalizedNumberCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq '注釈'

        # 注釈を表示ボタンをクリックすると開く
        expect(page).not_to have_selector('#HospitalizedNumberCard .NotesExpansionPanel .v-expansion-panel--active')
        sleep 0.5
        find('#HospitalizedNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#HospitalizedNumberCard .NotesExpansionPanel .v-expansion-panel--active')

        # 注釈の中身をチェック
        expect(find("#HospitalizedNumberCard .NotesExpansionPanel .v-expansion-panel-content table[class^=beds] > caption").text).to eq '岩手県の病床確保計画'

        # 注釈を表示ボタンをクリックすると閉じる
        expect(page).to have_selector('#HospitalizedNumberCard .NotesExpansionPanel .v-expansion-panel--active')
        find('#HospitalizedNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).not_to have_selector('#HospitalizedNumberCard .NotesExpansionPanel .v-expansion-panel--active')

        # データを表示と注釈を表示の両方を開く
        expect(page).not_to have_selector('#HospitalizedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        expect(page).not_to have_selector('#HospitalizedNumberCard .NotesExpansionPanel .v-expansion-panel--active')
        find('#HospitalizedNumberCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        find('#HospitalizedNumberCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#HospitalizedNumberCard .DataViewExpansionPanel .v-expansion-panel--active')
        expect(page).not_to have_selector('#HospitalizedNumberCard .NotesExpansionPanel .v-expansion-panel--active')
      end
    end

  end
end

require 'spec_helper'

patient_municipalities_json = JSON.parse(File.read(File.join(__dir__, '../../data/patient_municipalities.json')))
ja_json = JSON.parse(File.read(File.join(__dir__, '../../assets/locales/ja.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
      render_lazy_contents
      page.scroll_to('#ConfirmedCasesByMunicipalitiesCard')
    end

    describe '陽性患者数(市町村別)(ConfirmedCasesByMunicipalitiesCard)' do
      it '項目の値' do
        # h3
        expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Header > div > div > h3').text).to eq '陽性患者数（市町村別）'

        # 日付
        d = Date.parse(patient_municipalities_json['date']).strftime("%-m月%-d日")
        expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Header > div > div > div > small').text).to eq ja_json['Common']['{date}の累計'].gsub('{date}', d)

        # テーブルの上から1行目をチェックする(市町村)
        d = patient_municipalities_json['datasets']['data'].first['label']
        expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(1) > td:nth-child(1)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(ふりがな)
        d = patient_municipalities_json['datasets']['data'].first['ruby']
        expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(陽性者数)
        d = number_to_delimited(patient_municipalities_json['datasets']['data'].first['count'])
        expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(陽性者数/人口)
        d = "#{patient_municipalities_json['datasets']['data'].first['count_per_population']}%"
        expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(1) > td:nth-child(4)').text).to eq "#{d}"

        # ふりがなをクリックしてソートしたら、一番上は「いちのせきし」
        find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th:nth-child(2)').click
        expect(page).to have_selector '#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > thead > tr > th.text-start.sortable.active.asc'
        expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(1) > td:nth-child(1)').text).to eq '一関市'
        expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Content > div > div > table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq 'いちのせきし'

        # 注釈を表示ボタンの文言
        expect(find('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq '注釈'

        # 注釈を表示ボタンをクリックすると開く
        expect(page).not_to have_selector('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content')
        find('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content')

        # 注釈の中身をチェック
        expect(find("#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(1)").text).to eq '前日までに報告された陽性者の居住地を元にした累計値'
        expect(find("#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(2)").text).to eq '意向により居住地が公表されない場合は累計に含まれない'
        expect(find("#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(3)").text).to eq '例えば、県外や他地域在住であるが、盛岡市の検査で陽性になった場合、盛岡市として集計される場合がある'
        expect(find("#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content ul > li:nth-child(4)").text).to eq '陽性者数/人口 は市町村の人口(令和2年10月1日現在)に対する陽性者数の割合'

        # 注釈を表示ボタンをクリックすると閉じる
        expect(page).to have_selector('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content')
        find('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).not_to have_selector('#ConfirmedCasesByMunicipalitiesCard .NotesExpansionPanel .v-expansion-panel-content')
      end
    end

  end
end

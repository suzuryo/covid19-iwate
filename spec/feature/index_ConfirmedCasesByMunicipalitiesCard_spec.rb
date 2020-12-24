require 'spec_helper'

patient_municipalities_json = JSON.parse(File.read(File.join(__dir__, '../../data/patient_municipalities.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
    end

    describe '陽性患者数(市町村別)(ConfirmedCasesByMunicipalitiesCard)' do
      it '項目の値' do
        # h3
        expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Header > div > div > h3').text).to eq '陽性患者数（市町村別）'

        # 日付
        d = Date.parse(patient_municipalities_json['date']).strftime("%m月%d日")
        expect(find('#ConfirmedCasesByMunicipalitiesCard > div > div > div.DataView-Header > div > div > div > small').text).to eq "#{d}の累計"

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
      end
    end

  end
end

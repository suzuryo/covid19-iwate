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
        d = Date.parse(positive_status_json['data'].last['date']).strftime("%m月%d日")
        expect(find('#HospitalizedNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to eq "#{d}の合計"

        # テーブルを表示をクリック
        find('#HospitalizedNumberCard > div > div > div.DataView-ExpantionPanel > div > div > button').click

        # テーブルの上から1行目をチェックする(日付)
        d = Date.parse(positive_status_json['data'].last['date']).strftime("%m月%d日")
        expect(find('#HospitalizedNumberCard > div > div > div.DataView-ExpantionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(1) > th').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(入院)
        d = number_to_delimited(positive_status_json['data'].last['hospital'].to_i)
        expect(find('#HospitalizedNumberCard > div > div > div.DataView-ExpantionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(宿泊療養)
        d = number_to_delimited(positive_status_json['data'].last['hotel'].to_i)
        expect(find('#HospitalizedNumberCard > div > div > div.DataView-ExpantionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(計)
        d = number_to_delimited(positive_status_json['data'].last['hospitalized'].to_i)
        expect(find('#HospitalizedNumberCard > div > div > div.DataView-ExpantionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(1) > td:nth-child(4)').text).to eq "#{d}"
      end
    end

  end
end

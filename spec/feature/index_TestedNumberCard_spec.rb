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

        # テーブルを表示をクリック
        find('#TestedNumberCard > div > div > div.DataView-ExpansionPanel > div > div > button').click

        # テーブルの上から2行目をチェックする(日付)
        d = Date.parse(positive_rate_json['data'].last['diagnosed_date']).strftime("%-m月%-d日")
        expect(find('#TestedNumberCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(1) > th').text).to eq "#{d}"

        # テーブルの上から2行目をチェックする(PCR検査実施件数・日別)
        d = number_to_delimited(positive_rate_json['data'].last['pcr_positive_count'].to_i + positive_rate_json['data'].last['pcr_negative_count'].to_i)
        expect(find('#TestedNumberCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から2行目をチェックする(PCR検査実施件数・累計)
        d = number_to_delimited(positive_rate_json['data'].reduce(0){|sum, n| sum + n['pcr_positive_count'].to_i + + n['pcr_negative_count'].to_i})
        expect(find('#TestedNumberCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq "#{d}"

        # テーブルの上から2行目をチェックする(抗原検査実施件数・日別)
        d = number_to_delimited(positive_rate_json['data'].last['antigen_positive_count'].to_i + positive_rate_json['data'].last['antigen_negative_count'].to_i)
        expect(find('#TestedNumberCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(1) > td:nth-child(4)').text).to eq "#{d}"

        # テーブルの上から2行目をチェックする(抗原検査実施件数・累計)
        d = number_to_delimited(positive_rate_json['data'].reduce(0){|sum, n| sum + n['antigen_positive_count'].to_i + + n['antigen_negative_count'].to_i})
        expect(find('#TestedNumberCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(1) > td:nth-child(5)').text).to eq "#{d}"
      end
    end

  end
end

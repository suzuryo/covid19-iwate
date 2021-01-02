require 'spec_helper'

positive_rate_json = JSON.parse(File.read(File.join(__dir__, '../../data/positive_rate.json')))
daily_positive_detail_json = JSON.parse(File.read(File.join(__dir__, '../../data/daily_positive_detail.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
    end

    describe '検査の陽性率(PositiveRateCard)' do
      it '項目の値' do
        # h3
        expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq '検査の陽性率'
        expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(2) > h3').text).to eq 'PCR検査の7日間移動平均'

        # 日付
        d = Date.parse(positive_rate_json['data'].last['diagnosed_date']).strftime("%-m月%-d日")
        expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(1) > div > small').text).to match "^#{d} の数値"
        expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(2) > div > small').text).to match "^#{d} の数値"

        # 検査の陽性率
        d = number_to_delimited(positive_rate_json['data'].last['positive_rate'].round(1))
        expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(1) > div > span > strong').text).to eq "#{d}"

        # 検査の陽性率(実際に計算する)
        a = (daily_positive_detail_json['data'][-7..-1].reduce(0){|sum, n| sum + n['count'].to_i} / 7.0)
        b = (positive_rate_json['data'][-7..-1].reduce(0){|sum, n| sum + n['pcr_positive_count'].to_i + n['pcr_negative_count'].to_i + n['antigen_positive_count'].to_i + n['antigen_negative_count'].to_i} / 7.0)
        d = number_to_delimited((a / b * 100).round(1))
        expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(1) > div > span > strong').text).to eq "#{d}"

        # PCR検査の7日間移動平均(実際に計算する)
        d = number_to_delimited((positive_rate_json['data'][-7..-1].reduce(0){|sum, n| sum + n['pcr_positive_count'].to_i + n['pcr_negative_count'].to_i} / 7.0).round(1))
        expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(2) > div > span > strong').text).to eq "#{d}"

        # テーブルを表示をクリック
        find('#PositiveRateCard > div > div > div.DataView-ExpansionPanel > div > div > button').click

        # テーブルの上から4行目をチェックする(日付)
        d = Date.parse(positive_rate_json['data'][-4]['diagnosed_date']).strftime("%-m月%-d日")
        expect(find('#PositiveRateCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(4) > th').text).to eq "#{d}"

        # テーブルの上から4行目をチェックする(PCR検査陽性者数)
        d = number_to_delimited(positive_rate_json['data'][-4]['pcr_positive_count'].to_i)
        expect(find('#PositiveRateCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(4) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から4行目をチェックする(抗原検査陽性者数)
        d = number_to_delimited(positive_rate_json['data'][-4]['antigen_positive_count'].to_i)
        expect(find('#PositiveRateCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(4) > td:nth-child(3)').text).to eq "#{d}"

        # テーブルの上から4行目をチェックする(PCR検査陰性者数)
        d = number_to_delimited(positive_rate_json['data'][-4]['pcr_negative_count'].to_i)
        expect(find('#PositiveRateCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(4) > td:nth-child(4)').text).to eq "#{d}"

        # テーブルの上から4行目をチェックする(抗原検査陰性者数)
        d = number_to_delimited(positive_rate_json['data'][-4]['antigen_negative_count'].to_i)
        expect(find('#PositiveRateCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(4) > td:nth-child(5)').text).to eq "#{d}"

        # テーブルの上から4行目をチェックする(検査件数 7-MA)
        d = number_to_delimited(positive_rate_json['data'][-4]['weekly_average_diagnosed_count'].to_f)
        expect(find('#PositiveRateCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(4) > td:nth-child(6)').text).to eq "#{d}"

        # テーブルの上から4行目をチェックする(陽性率)
        d = number_to_delimited(positive_rate_json['data'][-4]['positive_rate'].round(1))
        expect(find('#PositiveRateCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(4) > td:nth-child(7)').text).to eq "#{d}"
      end
    end

  end
end

require 'spec_helper'

data_json = JSON.parse(File.read(File.join(__dir__, '../../data/data.json')))
positive_rate_json = JSON.parse(File.read(File.join(__dir__, '../../data/positive_rate.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
    end

    describe '新規陽性者数の7日間移動平均(MonitoringConfirmedCasesNumberCard)' do
      it '項目の値' do
        # h3
        expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div > h3').text).to eq '新規陽性者数の7日間移動平均'

        # 日付
        d = Date.parse(positive_rate_json['data'].last['diagnosed_date']).strftime("%m月%d日")
        expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to match "^#{d} の数値"

        # 新規陽性者数の7日間移動平均
        d = number_to_delimited((data_json['patients_summary']['data'][-7..-1].reduce(0){|sum, n| sum + n['小計'].to_i} / 7.0).round(1))
        expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq "#{d}"

        # テーブルを表示をクリック
        find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-ExpantionPanel > div > div > button').click

        # テーブルの上から2番目の値を確認(日付)
        d = Date.parse(positive_rate_json['data'][-2]['diagnosed_date']).strftime("%m月%d日")
        expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-ExpantionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(2) > th').text).to eq "#{d}"

        # テーブルの上から2番目の値を確認(陽性者数)
        d = number_to_delimited(positive_rate_json['data'][-2]['positive_count'].to_i)
        expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-ExpantionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(2) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から2番目の値を確認(7日間移動平均)
        d = number_to_delimited((positive_rate_json['data'][-8..-2].reduce(0){|sum, n| sum + n['positive_count'].to_i} / 7.0).round(1))
        expect(find('#MonitoringConfirmedCasesNumberCard > div > div > div.DataView-ExpantionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(2) > td:nth-child(3)').text).to eq "#{d}"
      end
    end

  end
end

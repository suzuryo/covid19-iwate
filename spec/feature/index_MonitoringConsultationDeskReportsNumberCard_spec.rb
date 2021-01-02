require 'spec_helper'

data_json = JSON.parse(File.read(File.join(__dir__, '../../data/data.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
    end

    describe '受診・相談センター 受付件数(MonitoringConsultationDeskReportsNumberCard)' do
      it '項目の値' do
        # h3
        expect(find('#MonitoringConsultationDeskReportsNumberCard > div > div > div.DataView-Header > div > div > h3').text).to eq '受診・相談センター 受付件数'

        # 日付
        d = Date.parse(data_json['querents']['data'].last['日付']).strftime("%-m月%-d日")
        expect(find('#MonitoringConsultationDeskReportsNumberCard > div > div > div.DataView-Header > div > div > div > small').text).to match "^#{d} 実績値"

        # 受診・相談センター受付件数
        d = number_to_delimited(data_json['querents']['data'].last['小計'].to_i)
        expect(find('#MonitoringConsultationDeskReportsNumberCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq "#{d}"

        # テーブルを表示をクリック
        find('#MonitoringConsultationDeskReportsNumberCard > div > div > div.DataView-ExpansionPanel > div > div > button').click

        # テーブルの上から1行目をチェックする(日付)
        d = Date.parse(data_json['querents']['data'].last['日付']).strftime("%-m月%-d日")
        expect(find('#MonitoringConsultationDeskReportsNumberCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(1) > th').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(受診・相談センター受付件数・日別)
        d = number_to_delimited(data_json['querents']['data'].last['小計'].to_i)
        expect(find('#MonitoringConsultationDeskReportsNumberCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(受診・相談センター受付件数・累計)
        d = number_to_delimited(data_json['querents']['data'].reduce(0){|sum, n| sum + n['小計'].to_i})
        expect(find('#MonitoringConsultationDeskReportsNumberCard > div > div > div.DataView-ExpansionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq "#{d}"
      end
    end

  end
end

require 'spec_helper'

daily_positive_detail_json = JSON.parse(File.read(File.join(__dir__, '../../data/daily_positive_detail.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
    end

    describe '接触歴等不明者数(7日間移動平均)(UntrackedRateCard)' do
      it '項目の値' do
        # h3
        expect(find('#UntrackedRateCard > div > div > div.DataView-Header > div > div > h3').text).to eq '接触歴等不明者数(7日間移動平均)'

        # 日付
        d = Date.parse(daily_positive_detail_json['data'].last['diagnosed_date']).strftime("%-m月%-d日")
        expect(find('#UntrackedRateCard > div > div > div.DataView-Header > div > div > div > small').text).to match "^#{d} の数値"

        # 接触歴等不明者数(7日間移動平均)
        d = number_to_delimited((daily_positive_detail_json['data'].last['weekly_average_untracked_count']).round(1))
        expect(find('#UntrackedRateCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq "#{d}"

        # 接触歴等不明者数(7日間移動平均)(実際に計算してみる)
        d = number_to_delimited((daily_positive_detail_json['data'][-7..-1].reduce(0){|sum, n| sum + n['missing_count'].to_i} / 7.0).round(1))
        expect(find('#UntrackedRateCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq "#{d}"

        # テーブルを表示をクリック
        find('#UntrackedRateCard > div > div > div.DataView-ExpantionPanel > div > div > button').click

        # テーブルの上から3番目の値(日別)
        d = Date.parse(daily_positive_detail_json['data'][-3]['diagnosed_date']).strftime("%-m月%-d日")
        expect(find('#UntrackedRateCard > div > div > div.DataView-ExpantionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(3) > th').text).to eq "#{d}"

        # テーブルの上から3番目の値を確認(接触歴等判明者数)
        d = number_to_delimited(daily_positive_detail_json['data'][-3]['reported_count'].to_i)
        expect(find('#UntrackedRateCard > div > div > div.DataView-ExpantionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(3) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から3番目の値を確認(接触歴等不明者数)
        d = number_to_delimited(daily_positive_detail_json['data'][-3]['missing_count'].to_i)
        expect(find('#UntrackedRateCard > div > div > div.DataView-ExpantionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(3) > td:nth-child(3)').text).to eq "#{d}"

        # テーブルの上から3番目の値を確認(接触歴等不明者数7日間移動平均)(実際に計算してみる)
        d = number_to_delimited((daily_positive_detail_json['data'][-9..-3].reduce(0){|sum, n| sum + n['missing_count'].to_i} / 7.0).round(1))
        expect(find('#UntrackedRateCard > div > div > div.DataView-ExpantionPanel > div > div > div > div > div > div > table > tbody > tr:nth-child(3) > td:nth-child(4)').text).to eq "#{d}"
      end
    end

  end
end

require 'spec_helper'

data_json = JSON.parse(File.read(File.join(__dir__, '../../data/data.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/]' do

    before do
      visit '/'
    end

    describe '陽性者の属性(ConfirmedCasesAttributesCard)' do
      it '項目の値' do
        # h3
        expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Header > div > div > h3').text).to eq '陽性者の属性'

        # 陽性者の合計
        d = data_json['patients']['data'].size
        expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Header > div > div > div > span > strong').text).to eq "#{d}"

        # 陽性者の合計の日付
        d = Date.parse(data_json['patients']['date']).strftime("%m月%d日")
        expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Header > div > div > div > small').text).to eq "#{d}の累計"

        # テーブルの上から1行目をチェックする(通番)
        d = "事例#{data_json['patients']['data'].last['id'].to_s.rjust(4, '0')}"
        expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > th').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(url)
        d = data_json['patients']['data'].last['url']
        if d
          expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > th > a')[:href]).to eq "#{d}"
        end

        # テーブルの上から1行目をチェックする(確定日)
        d = Date.parse(data_json['patients']['data'].last['確定日']).strftime("%m月%d日")
        expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(発症日)
        if data_json['patients']['data'].last&.[]('無症状')
          d = "無症状"
        elsif data_json['patients']['data'].last&.[]('発症日')
          d = "#{(Date.parse(data_json['patients']['data'].last&.[]('確定日')) - Date.parse(data_json['patients']['data'].last&.[]('発症日'))).to_i}日前"
        else
          d = "不明"
        end
        expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(3)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(居住地)
        d = data_json['patients']['data'].last['居住地']
        expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(4)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(年代)
        d = data_json['patients']['data'].last['年代']
        expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(5)').text).to eq "#{d}"

        # テーブルの上から1行目をチェックする(📺)
        d = data_json['patients']['data'].last['会見']
        if d
          expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > td:nth-child(6) > a')[:href]).to eq "#{d}"
        end

        # 最初は1ページあたり15件なので16番目のtrは無い
        expect(page.all('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(16)').empty?).to eq true

        # 次のページ
        find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-footer > div.v-data-footer__icons-after > button').click

        # 次のページの先頭は16番目の要素
        d = "事例#{data_json['patients']['data'][-16]['id'].to_s.rjust(4, '0')}"
        expect(find('#ConfirmedCasesAttributesCard > div > div > div.DataView-Content > div > div.v-data-table__wrapper > table > tbody > tr:nth-child(1) > th').text).to eq "#{d}"
      end
    end

  end
end

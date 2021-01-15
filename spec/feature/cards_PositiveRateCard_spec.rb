require 'spec_helper'

positive_rate_json = JSON.parse(File.read(File.join(__dir__, '../../data/positive_rate.json')))
daily_positive_detail_json = JSON.parse(File.read(File.join(__dir__, '../../data/daily_positive_detail.json')))
ja_json = JSON.parse(File.read(File.join(__dir__, '../../assets/locales/ja.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/positive-rate]' do

    before do
      visit '/cards/positive-rate'
      render_lazy_contents
      page.scroll_to('#PositiveRateCard')
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
        d = number_to_delimited(page.evaluate_script("#{positive_rate_json['data'].last['positive_rate']}.toFixed(1)"))
        expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(1) > div > span > strong').text).to eq "#{d}"

        # 検査の陽性率(実際に計算する)
        a = (daily_positive_detail_json['data'][-7..-1].reduce(0){|sum, n| sum + n['count'].to_i} / 7.0)
        b = (positive_rate_json['data'][-7..-1].reduce(0){|sum, n| sum + n['pcr_positive_count'].to_i + n['pcr_negative_count'].to_i + n['antigen_positive_count'].to_i + n['antigen_negative_count'].to_i} / 7.0)
        d = number_to_delimited((a / b * 100).round(1))
        expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(1) > div > span > strong').text).to eq "#{d}"

        # PCR検査の7日間移動平均(実際に計算する)
        d = number_to_delimited((positive_rate_json['data'][-7..-1].reduce(0){|sum, n| sum + n['pcr_positive_count'].to_i + n['pcr_negative_count'].to_i} / 7.0).round(1))
        expect(find('#PositiveRateCard > div > div > div.DataView-Header > div > div:nth-child(2) > div > span > strong').text).to eq "#{d}"

        # データを表示ボタンの文言
        expect(find('#PositiveRateCard .DataViewExpansionPanel button.v-expansion-panel-header').text).to eq 'データを表示'

        # データを表示ボタンをクリックすると開く
        expect(page).not_to have_selector('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel--active')
        find('#PositiveRateCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel--active')

        # テーブルの上から4行目をチェックする(日付)
        d = Date.parse(positive_rate_json['data'][-4]['diagnosed_date']).strftime("%-m月%-d日")
        expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > th').text).to eq "#{d}"

        # テーブルの上から4行目をチェックする(PCR検査陽性者数)
        d = number_to_delimited(positive_rate_json['data'][-4]['pcr_positive_count'].to_i)
        expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > td:nth-child(2)').text).to eq "#{d}"

        # テーブルの上から4行目をチェックする(抗原検査陽性者数)
        d = number_to_delimited(positive_rate_json['data'][-4]['antigen_positive_count'].to_i)
        expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > td:nth-child(3)').text).to eq "#{d}"

        # テーブルの上から4行目をチェックする(PCR検査陰性者数)
        d = number_to_delimited(positive_rate_json['data'][-4]['pcr_negative_count'].to_i)
        expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > td:nth-child(4)').text).to eq "#{d}"

        # テーブルの上から4行目をチェックする(抗原検査陰性者数)
        d = number_to_delimited(positive_rate_json['data'][-4]['antigen_negative_count'].to_i)
        expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > td:nth-child(5)').text).to eq "#{d}"

        # テーブルの上から4行目をチェックする(検査件数 7-MA)
        d = number_to_delimited(page.evaluate_script("#{positive_rate_json['data'][-4]['weekly_average_diagnosed_count']}.toFixed(1)"))
        expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > td:nth-child(6)').text).to eq "#{d}"

        # テーブルの上から4行目をチェックする(陽性率)
        d = number_to_delimited(page.evaluate_script("#{positive_rate_json['data'][-4]['positive_rate']}.toFixed(1)"))
        expect(find('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel-content table > tbody > tr:nth-child(4) > td:nth-child(7)').text).to eq "#{d}"

        # データを表示ボタンをクリックすると閉じる
        expect(page).to have_selector('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel--active')
        find('#PositiveRateCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        expect(page).not_to have_selector('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel--active')

        # 注釈を表示ボタンの文言
        expect(find('#PositiveRateCard .NotesExpansionPanel button.v-expansion-panel-header').text).to eq '注釈'

        # 注釈を表示ボタンをクリックすると開く
        expect(page).not_to have_selector('#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content')
        sleep 0.5
        find('#PositiveRateCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content')

        # 注釈の中身をチェック
        expect(find("#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content div[class^=newScenario] ul > li:nth-child(1)").text).to eq ja_json['PositiveRateCard']['b'][0]
        expect(find("#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content div[class^=newScenario] ul > li:nth-child(2)").text).to eq ja_json['Common']['7MA']
        expect(find("#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content div[class^=newScenario] ul > li:nth-child(3)").text).to eq ja_json['Common']['検査結果の判明日を基準とする']
        expect(find("#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content div[class^=newScenario] ul > li:nth-child(4)").text).to eq ja_json['PositiveRateCard']['b'][1]

        expect(find("#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content div[class^=newScenarioSummarry] > p:nth-child(1) > strong").text).to eq ja_json['PositiveRateCard']['c'][0]
        expect(find("#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content div[class^=newScenarioSummarry] > p:nth-child(2)").text).to eq ja_json['PositiveRateCard']['c'][1]
        expect(find("#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content div[class^=newScenarioExternalLink] a").text).to eq ja_json['ExtLink']['岩手県17_2']['text']

        # 注釈を表示ボタンをクリックすると閉じる
        expect(page).to have_selector('#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content')
        find('#PositiveRateCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).not_to have_selector('#PositiveRateCard .NotesExpansionPanel .v-expansion-panel-content')

        # データを表示と注釈を表示の両方を開く
        expect(page).not_to have_selector('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel--active')
        expect(page).not_to have_selector('#PositiveRateCard .NotesExpansionPanel .v-expansion-panel--active')
        find('#PositiveRateCard .DataViewExpansionPanel button.v-expansion-panel-header').click
        sleep 1
        find('#PositiveRateCard .NotesExpansionPanel button.v-expansion-panel-header').click
        expect(page).to have_selector('#PositiveRateCard .DataViewExpansionPanel .v-expansion-panel--active')
        expect(page).to have_selector('#PositiveRateCard .NotesExpansionPanel .v-expansion-panel--active')

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#PositiveRateCard nav ul.v-breadcrumbs')
        expect(find('#PositiveRateCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq ja_json['Common']['ホーム']
        expect(find('#PositiveRateCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '検査の陽性率'
      end
    end
  end
end

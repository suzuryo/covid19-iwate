require 'spec_helper'

data_json = JSON.parse(File.read(File.join(__dir__, '../../../data/data.json')))
ja_json = JSON.parse(File.read(File.join(__dir__, '../../../assets/locales/ja.json')))

describe "iPhone 6/7/8", type: :feature do
  context 'page [/cards/details-of-confirmed-cases]' do

    before do
      visit '/cards/details-of-confirmed-cases'
      render_lazy_contents
      page.scroll_to('#ConfirmedCasesDetailsCard')
    end

    describe '検査陽性者の状況(ConfirmedCasesDetailsCard)' do
      it '項目の値' do
        # h3
        expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Header > div > div > h3').text).to eq '検査陽性者の状況'

        # 陽性者数（累計）
        d = number_to_delimited(data_json['patients']['data'].last['id'])
        expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > div > span:nth-child(2) > strong').text).to eq "#{d}"

        # 入院
        d = number_to_delimited(data_json['main_summary']['children'][0]['children'][0]['value'])
        expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(1) > div > span:nth-child(2) > strong').text).to eq "#{d}"

        # 重症
        d = number_to_delimited(data_json['main_summary']['children'][0]['children'][0]['children'][1]['value'])
        expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(1) > ul > li > div > span:nth-child(2) > strong').text).to eq "#{d}"

        # 宿泊療養
        d = number_to_delimited(data_json['main_summary']['children'][0]['children'][1]['value'])
        expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(2) > div > span:nth-child(2) > strong').text).to eq "#{d}"


        # 自宅療養
        d = number_to_delimited(data_json['main_summary']['children'][0]['children'][2]['value'])
        expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(3) > div > span:nth-child(2) > strong').text).to eq "#{d}"

        # 入院・療養等調整中
        d = number_to_delimited(data_json['main_summary']['children'][0]['children'][3]['value'])
        expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(4) > div > span:nth-child(2) > strong').text).to eq "#{d}"

        # 退院等
        d = number_to_delimited(data_json['main_summary']['children'][0]['children'][5]['value'])
        expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(5) > div > span:nth-child(2) > strong').text).to eq "#{d}"

        # 死亡
        d = number_to_delimited(data_json['main_summary']['children'][0]['children'][4]['value'])
        expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(6) > div > span:nth-child(2) > strong').text).to eq "#{d}"

        # cards の 個別ページでは breadcrumbs が表示される
        expect(page).to have_selector('#ConfirmedCasesDetailsCard nav ul.v-breadcrumbs')
        expect(find('#ConfirmedCasesDetailsCard > nav > ul.v-breadcrumbs > li:nth-child(1) > a').text).to eq ja_json['Common']['ホーム']
        expect(find('#ConfirmedCasesDetailsCard > nav > ul.v-breadcrumbs > li:nth-child(3) > a').text).to eq '検査陽性者の状況'
      end
    end

  end
end

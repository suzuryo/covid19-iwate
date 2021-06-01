# frozen_string_literal: true

require 'spec_helper'

def has_site_top_upper(lang:, data:)
  lang_json = data[:json]

  expect(page).to have_selector '.appContainer > main.mainContainer > div.container > div > div.SiteTopUpper'

  if lang == :ja
    expect(URI(find('.SiteTopUpper > div.v-lazy > span > a:nth-child(1).StaticInfo.Link')['href']).path).to eq '/flow/'
  else
    expect(URI(find('.SiteTopUpper > div.v-lazy > span > a:nth-child(1).StaticInfo.Link')['href']).path).to eq "/#{lang}/flow/"
  end

  # 電話相談をどうぞ
  expect(find('.SiteTopUpper > div.v-lazy > span > a:nth-child(1).StaticInfo.Link').text).to eq "#{lang_json['SiteTopUpper']['電話相談をどうぞ']}\n#{lang_json['SiteTopUpper']['相談の手順を見る']}"
  expect(find('.SiteTopUpper > div.v-lazy > span > a:nth-child(1).StaticInfo.Link > div > button').text).to eq lang_json['SiteTopUpper']['相談の手順を見る'].to_s

  # 初期表示の時のALERT_ITEMSの順番
  check_alert_items(lang)

  # 検査要請者の状況の /cards/details-of-confirmed-cases に移動して
  find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Header > div > div > h3 > a').click

  # その後に左上のログをクリックして / に戻ったら
  find('#app > div > div.appContainer > div > div > header > h1 > a').click

  # それでもALERT_ITEMSの順番が保たれている
  check_alert_items(lang)
end

def check_alert_items(lang)
  ALERT_ITEMS.each_with_index do |d, index|
    a = d['text'][lang.to_s] || d['text']['ja']
    b = d['url'][lang.to_s] || d['url']['ja']
    # 外部URLの時は .ExternalLink、内部URLの時は .Link
    c = URI.parse(b).hostname.nil? ? 'Link' : 'ExternalLink'
    # url が http から始まらない /card/ のような場合はホスト名を補完
    b = "#{Capybara.app_host}#{b}" if c === 'Link'
    expect(find(".SiteTopUpper > div.v-lazy > span > a.alertItem:nth-child(#{index + 2}).StaticInfo.#{c}").text).to eq a
    expect(find(".SiteTopUpper > div.v-lazy > span > a.alertItem:nth-child(#{index + 2}).StaticInfo.#{c}")['href']).to eq b
  end
end

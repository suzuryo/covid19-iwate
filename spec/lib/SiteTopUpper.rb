# frozen_string_literal: true

require 'spec_helper'

def has_site_top_upper(lang:, data:)
  lang_json = data[:json]

  # h2
  expect(find('.MainPage > .Header > .header > h2.pageTitle').text).to eq lang_json['Common']['岩手の最新感染動向'].to_s
  expect(page).to have_selector('.MainPage > .Header > .header > h2.pageTitle span.v-icon svg')

  # UpdatedAt
  expect(find('.MainPage > .Header > .UpdatedAt > span').text).to eq lang_json['SiteTopUpper']['最終更新'].to_s

  # 電話相談をどうぞ
  expect(find('.MainPage > a:nth-child(2).StaticInfo.Link').text).to eq "#{lang_json['SiteTopUpper']['電話相談をどうぞ']}\n#{lang_json['SiteTopUpper']['相談の手順を見る']}"
  expect(find('.MainPage > a:nth-child(2).StaticInfo.Link > div.StaticInfo-Button > button').text).to eq lang_json['SiteTopUpper']['相談の手順を見る'].to_s

  if lang == :ja
    # time
    expect(find('.MainPage > .Header > .UpdatedAt > time').text).to eq Time.parse(DATA_JSON['lastUpdate']).strftime('%Y年%-m月%-d日 %-H:%M JST')
    # Annotation
    expect(page).not_to have_selector('.MainPage > .Header > .Annotation')
    expect(URI(find('.MainPage > a:nth-child(2).StaticInfo.Link')['href']).path).to eq '/flow/'
  else
    # time
    expect(find('.MainPage > .Header > .UpdatedAt > time').text).to eq Time.parse(DATA_JSON['lastUpdate']).strftime('%b %-d, %Y, %H:%M JST')
    # Annotation
    expect(find('.MainPage > .Header > .Annotation > span').text).to eq lang_json['SiteTopUpper']['注釈'].to_s
    expect(URI(find('.MainPage > a:nth-child(2).StaticInfo.Link')['href']).path).to eq "/#{lang}/flow/"
  end

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
    expect(find(".MainPage > a.alertItem:nth-child(#{index + 3}).StaticInfo.#{c}").text).to eq a
    expect(find(".MainPage > a.alertItem:nth-child(#{index + 3}).StaticInfo.#{c}")['href']).to eq b
  end
end

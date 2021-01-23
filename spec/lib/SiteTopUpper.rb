require 'spec_helper'

def has_site_top_upper(locale: 'ja')

  locale_json = JA_JSON if locale === 'ja'
  locale_json = EN_JSON if locale === 'en'

  # h2
  expect(find('.MainPage > .Header > .header > h2.pageTitle').text).to eq locale_json['Common']["岩手の最新感染動向"].to_s
  expect(page).to have_selector('.MainPage > .Header > .header > h2.pageTitle span.v-icon svg')

  # UpdatedAt
  expect(find('.MainPage > .Header > .UpdatedAt > span').text).to eq locale_json['SiteTopUpper']['最終更新'].to_s

  # 電話相談をどうぞ
  expect(find('.MainPage > a:nth-child(2) > span:nth-child(1)').text).to eq locale_json['SiteTopUpper']['電話相談をどうぞ'].to_s
  expect(find('.MainPage > a:nth-child(2) > div.StaticInfo-Button > span').text).to eq locale_json['SiteTopUpper']['相談の手順を見る'].to_s
  ALERT_ITEMS.each_with_index do |d, index|
    expect(find(".MainPage > a:nth-child(#{index+3}).StaticInfo > span").text).to eq (d['text'][locale] ? d['text'][locale] : d['text']['ja'])
  end

  if locale == 'ja'
    # time
    expect(find('.MainPage > .Header > .UpdatedAt > time').text).to eq Time.parse(DATA_JSON['lastUpdate']).strftime("%Y年%-m月%-d日 %H:%M JST")
    # Annotation
    expect(page).not_to have_selector('.MainPage > .Header > .Annotation')
    expect(URI(find('.MainPage > a:nth-child(2).StaticInfo')['href']).path).to eq '/flow'
  else
    # time
    expect(find('.MainPage > .Header > .UpdatedAt > time').text).to eq Time.parse(DATA_JSON['lastUpdate']).strftime("%b %-d, %Y, %H:%M JST")
    # Annotation
    expect(find('.MainPage > .Header > .Annotation > span').text).to eq locale_json['SiteTopUpper']['注釈'].to_s
    expect(URI(find('.MainPage > a:nth-child(2).StaticInfo')['href']).path).to eq '/en/flow'
  end
end

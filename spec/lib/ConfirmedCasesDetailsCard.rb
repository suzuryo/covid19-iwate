# frozen_string_literal: true

require 'spec_helper'

def has_confirmed_cases_details_card(lang:, lang_json:)
  # h3
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Header > div > div > h3').text).to eq lang_json['ConfirmedCasesDetailsCard']['title'].to_s

  # 陽性者数（累計）
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > div > span:nth-child(1)').text).to eq "#{lang_json['Common']['陽性者数']} (#{lang_json['Common']['累計']})"
  d = number_to_delimited(DATA_JSON['patients']['data'].last['id'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 入院
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(1) > div > span:nth-child(1)').text).to eq lang_json['Common']['入院'].to_s
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][0]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(1) > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 重症
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(1) > ul > li > div > span:nth-child(1)').text).to eq lang_json['Common']['重症'].to_s
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][0]['children'][1]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(1) > ul > li > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 宿泊療養
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(2) > div > span:nth-child(1)').text).to eq lang_json['Common']['宿泊療養'].to_s
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][1]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(2) > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 自宅療養
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(3) > div > span:nth-child(1)').text).to eq lang_json['ConfirmedCasesDetailsCard']['legends'][0].to_s
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][2]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(3) > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 入院・療養等調整中
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(4) > div > span:nth-child(1)').text).to eq lang_json['ConfirmedCasesDetailsCard']['legends'][1].to_s
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][3]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(4) > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 退院等
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(5) > div > span:nth-child(1)').text).to eq lang_json['ConfirmedCasesDetailsCard']['legends'][2].to_s
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][5]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(5) > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 死亡
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(6) > div > span:nth-child(1)').text).to eq lang_json['ConfirmedCasesDetailsCard']['legends'][3].to_s
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][4]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(6) > div > span:nth-child(2) > strong').text).to eq d.to_s
end

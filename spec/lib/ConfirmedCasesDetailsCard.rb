require 'spec_helper'

def has_confirmed_cases_details_card
  # h3
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Header > div > div > h3').text).to eq '検査陽性者の状況'

  # 陽性者数（累計）
  d = number_to_delimited(DATA_JSON['patients']['data'].last['id'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 入院
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][0]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(1) > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 重症
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][0]['children'][1]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(1) > ul > li > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 宿泊療養
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][1]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(2) > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 自宅療養
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][2]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(3) > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 入院・療養等調整中
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][3]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(4) > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 退院等
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][5]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(5) > div > span:nth-child(2) > strong').text).to eq d.to_s

  # 死亡
  d = number_to_delimited(DATA_JSON['main_summary']['children'][0]['children'][4]['value'])
  expect(find('#ConfirmedCasesDetailsCard > div > div > div.DataView-Content > ul > li > ul > li:nth-child(6) > div > span:nth-child(2) > strong').text).to eq d.to_s
end

#!/usr/bin/env ruby
# frozen_string_literal: true

require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'json'
require 'time'
require 'date'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'
CREDENTIALS_PATH = 'credentials.json'
TOKEN_PATH = 'token.yaml'
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

def authorize
  client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
  token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
  authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
  user_id = 'default'
  credentials = authorizer.get_credentials user_id
  if credentials.nil?
    url = authorizer.get_authorization_url base_url: OOB_URI
    puts 'Open the following URL in the browser and enter the ' \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end

# Initialize the API
service = Google::Apis::SheetsV4::SheetsService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

# ここまで Google Sheets API を使うための Quickstart テンプレ
# https://developers.google.com/sheets/api/quickstart/ruby

######################################################################
# Google Sheets から データ取得
######################################################################
SPREADSHEET_ID = '1VjxD8YTwEngvkfYOLD-4JG1tA5AnzTlgnzDO1lkTlNc'

PATIENTS_RANGE = 'output_patients!A2:N'
output_patients = service.get_spreadsheet_values SPREADSHEET_ID, PATIENTS_RANGE
raise if output_patients.values.empty?

INSPECTIONS_RANGE = 'input_検査件数!A2:F'
output_inspections = service.get_spreadsheet_values SPREADSHEET_ID, INSPECTIONS_RANGE
raise if output_inspections.values.empty?

CONTACTS_RANGE = 'input_帰国者接触者_相談件数!A2:E'
output_contacts = service.get_spreadsheet_values SPREADSHEET_ID, CONTACTS_RANGE
raise if output_contacts.values.empty?

QUERENTS_RANGE = 'input_一般_相談件数!A2:E'
output_querents = service.get_spreadsheet_values SPREADSHEET_ID, QUERENTS_RANGE
raise if output_querents.values.empty?

PATIENT_MUNICIPALITIES_RANGE = 'output_patient_municipalities!A2:G'
output_patient_municipalities = service.get_spreadsheet_values SPREADSHEET_ID, PATIENT_MUNICIPALITIES_RANGE
raise if output_patient_municipalities.values.empty?

POSITIVE_BY_DIAGNOSED_RANGE = 'output_positive_by_diagnosed!A2:I'
output_positive_by_diagnosed = service.get_spreadsheet_values SPREADSHEET_ID, POSITIVE_BY_DIAGNOSED_RANGE
raise if output_positive_by_diagnosed.values.empty?

POSITIVE_RATE_RANGE = 'output_positive_rate!A2:I'
output_positive_rate = service.get_spreadsheet_values SPREADSHEET_ID, POSITIVE_RATE_RANGE
raise if output_positive_rate.values.empty?

HOSPITALIZED_NUMBER_RANGE = 'output_hospitalized_numbers!A2:E'
output_hospitalized_numbers = service.get_spreadsheet_values SPREADSHEET_ID, HOSPITALIZED_NUMBER_RANGE
raise if output_hospitalized_numbers.values.empty?

######################################################################
# データ生成 テンプレート
# data.json
######################################################################
now = Time.now
data_json = {
  'contacts': {
    'date': now.strftime('%Y/%m/%d %H:%M'),
    'data': []
  },
  'querents': {
    'date': now.strftime('%Y/%m/%d %H:%M'),
    'data': []
  },
  'patients': {
    'date': now.strftime('%Y/%m/%d %H:%M'),
    'data': []
  },
  'patients_summary': {
    'date': now.strftime('%Y/%m/%d %H:%M'),
    'data': []
  },
  'inspections_summary': {
    'date': now.strftime('%Y/%m/%d %H:%M'),
    'data': {
      'PCR検査': [],
      '抗原検査': []
    },
    'labels': []
  },
  'lastUpdate': now,
  'main_summary': {
    'attr': '検査実施件数',
    'date': now.strftime('%Y/%m/%d %H:%M'),
    'value': 0,
    'children': [
      {
        'attr': '陽性患者数',
        'value': 0,
        'children': [
          {
            'attr': '入院中',
            'value': 0,
            'children': [
              {
                'attr': '軽症・中等症',
                'value': 0
              },
              {
                'attr': '重症', # 岩手県がまだ発表していないので未使用
                'value': 0
              },
              {
                'attr': '不明', # 岩手県がまだ発表していないので未使用
                'value': 0
              }
            ]
          },
          {
            'attr': '宿泊療養', # 岩手県がまだ発表していないので未使用
            'value': 0
          },
          {
            'attr': '自宅療養', # 岩手県がまだ発表していないので未使用
            'value': 0
          },
          {
            'attr': '入院・療養等調整中',
            'value': 0
          },
          {
            'attr': '死亡', # 岩手県がまだ発表していないので未使用
            'value': 0
          },
          {
            'attr': '退院',
            'value': 0
          },
        ]
      }
    ]
  }
}

######################################################################
# data.json
# patients の生成
######################################################################
# 陽性者
# A: 0: id
# B: 1: リリース日
# C: 2: 陽性確定日
# D: 3: 年代
# E: 4: 性別
# F: 5: 居住地
# G: 6: 陽性者の状況
# H: 7: 入院日
# I: 8: 退院日
# J: 9: url
# K:10: 接触歴
# L:11: 通番
# K:12: 退院
# L:13: 確定からの経過日数

output_patients.values.each do |row|
  data_json[:'patients'][:'data'].append(
    {
      'id': row[0].to_i,
      'リリース日': Time.parse(row[1]).iso8601,
      '通番': row[11],
      '年代': row[3],
      '性別': row[4],
      '居住地': row[5],
      '退院': row[12] != '' ? row[12] : nil,
      'date': Time.parse(row[2]).strftime('%Y-%m-%d'),
      'url': row[9] != '' ? row[9] : nil,
    }
  )
end

######################################################################
# data.json
# patients_summary の生成
######################################################################
(Date.new(2020, 2, 15)..Date.today).each do |date|
  output_patients_sum = 0
  output_patients.values.each do |row|
    if row[1] === date.strftime('%Y/%m/%d')
      output_patients_sum += 1
    end
  end

  data_json[:'patients_summary'][:'data'].append(
    {
      '日付': Time.new(date.year, date.month, date.day, 8, 0, 0).iso8601,
      '小計': output_patients_sum
    }
  )
end

######################################################################
# data.json
# inspections_summary の生成
######################################################################
output_inspections.values.each do |row|
  data_json[:'inspections_summary'][:'data'][:'PCR検査'].append row[4].to_i
  data_json[:'inspections_summary'][:'data'][:'抗原検査'].append row[3].to_i
  data_json[:'inspections_summary'][:'labels'].append Time.parse(row[0]).strftime('%-m/%d')
end


######################################################################
# data.json
# main_summary の生成
######################################################################
# 検査実施件数
inspection_sum = 0
output_inspections.values.each do |row|
  inspection_sum += row[5].to_i
end
data_json[:'main_summary'][:'value'] = inspection_sum

# 陽性患者数
data_json[:'main_summary'][:'children'][0][:'value'] = output_patients.values.size

# 岩手県が個別の症状（軽症・中症・重症）を発表していないのでカウントできない
# 岩手県が個別の退院日を公表していないので Google Sheets の output_patients から
# カウントできないので、 Google Sheets の output_hospitalized_numbers で
# 手動管理する値を採用する
# 個別の退院日が発表され、個別の症状が発表されるならコメントアウトしているコードを利用できるようになる。

# 症状ごとのカウント
patients_status = {
  '軽症・中等症': 0,
  '重症': 0,
  '宿泊療養': 0,
  '自宅療養': 0,
  '入院・療養等調整中': 0,
  '死亡': 0,
  '退院等（要領期間経過も含む）': 0,
}
output_patients.values.each do |row|
  patients_status[row[6].to_sym] += 1
end

# 入院中
data_json[:'main_summary'][:'children'][0][:'children'][0][:'value'] = output_hospitalized_numbers.values.last[2].to_i

# 軽症・中等症 : 未発表なのでカウントできない
# 重症 : 未発表なのでカウントできない
# 不明 : 未発表なのでカウントできない

# 宿泊療養
data_json[:'main_summary'][:'children'][0][:'children'][1][:'value'] = patients_status[:'宿泊療養']

# 自宅療養
data_json[:'main_summary'][:'children'][0][:'children'][2][:'value'] = patients_status[:'自宅療養']

# 入院療養等調整中
data_json[:'main_summary'][:'children'][0][:'children'][3][:'value'] = patients_status[:'入院・療養等調整中']

# 死亡
data_json[:'main_summary'][:'children'][0][:'children'][4][:'value'] = output_hospitalized_numbers.values.last[3].to_i

# 退院
data_json[:'main_summary'][:'children'][0][:'children'][5][:'value'] = output_hospitalized_numbers.values.last[4].to_i


######################################################################
# data.json
# contacts の生成
######################################################################
output_contacts.values.each do |row|
  data_json[:'contacts'][:'data'].append(
    {
      '日付': Time.parse(row[0]).iso8601,
      'コールセンター': row[1].to_i,
      '各保健所': row[2].to_i,
      '医療政策室': row[3].to_i,
      '小計': row[4].to_i,
    }
  )
end

######################################################################
# data.querents.json
# querents の生成
######################################################################
output_querents.values.each do |row|
  data_json[:'querents'][:'data'].append(
    {
      '日付': Time.parse(row[0]).iso8601,
      'コールセンター': row[1].to_i,
      '各保健所': row[2].to_i,
      '医療政策室': row[3].to_i,
      '小計': row[4].to_i,
    }
  )
end

######################################################################
# データ生成 テンプレート
# data.patient_municipalities.json
######################################################################
data_patient_municipalities_json = {
  'date': now.strftime('%Y/%m/%d %H:%M'),
  'datasets': {
    'date': now.strftime('%Y/%m/%d %H:%M'),
    'data': []
  }
}

######################################################################
# data.patient_municipalities.json
# datasets の生成
######################################################################
output_patient_municipalities.values.each do |row|
  data_patient_municipalities_json[:'datasets'][:'data'].append(
    {
      'code': row[0],
      'area': row[1],
      'label': row[2],
      'ruby': row[3],
      'count': row[5].to_i
    }
  )
end

######################################################################
# データ生成 テンプレート
# positive_by_diagnosed.json
######################################################################
data_positive_by_diagnosed_json = {
  'date': now.strftime('%Y/%m/%d %H:%M'),
  'data': []
}

######################################################################
# positive_by_diagnosed.json
# data の生成
######################################################################
(Date.new(2020, 2, 15)..Date.today).each do |date|
  positive_by_diagnosed_sum = 0
  output_patients.values.each do |row|
    if row[2] === date.strftime('%Y/%m/%d')
      positive_by_diagnosed_sum += 1
    end
  end

  data_positive_by_diagnosed_json[:'data'].append(
    {
      'diagnosed_date': Time.new(date.year, date.month, date.day, 0, 0, 0).iso8601,
      'count': positive_by_diagnosed_sum
    }
  )
end

######################################################################
# データ生成 テンプレート
# data_daily_positive_detail.json
######################################################################
data_daily_positive_detail_json = {
  'date': now.strftime('%Y/%m/%d %H:%M'),
  'data': []
}

######################################################################
# data_daily_positive_detail.json
# data の生成
######################################################################
output_positive_by_diagnosed.values.each do |row|
  row[6].nil? || row[6].empty? ? row6 = nil : row6 = row[6].to_f
  row[7].nil? || row[7].empty? ? row7 = nil : row7 = row[7].to_f
  row[8].nil? || row[8].empty? ? row8 = nil : row8 = row[8].to_i
  data_daily_positive_detail_json[:'data'].append(
    {
      "diagnosed_date": Time.parse(row[0]).iso8601,
      "count": row[1].to_i,
      "missing_count": row[2].to_i,
      "reported_count": row[3].to_i,
      "weekly_gain_ratio": nil, # 未使用
      "untracked_percent": nil, # 未使用
      "weekly_average_count": row6,
      "weekly_average_untracked_count": row7,
      "weekly_average_untracked_increse_percent": row8
    }
  )
end

######################################################################
# データ生成 テンプレート
# positive_rate.json
######################################################################
data_positive_rate_json = {
  'date': now.strftime('%Y/%m/%d %H:%M'),
  'data': []
}

######################################################################
# positive_rate.json
# data の生成
######################################################################
output_positive_rate.values.each do |row|
  row[6].nil? || row[6].empty? ? row6 = nil : row6 = row[6].to_i
  row[7].nil? || row[7].empty? ? row7 = nil : row7 = row[7].to_f
  row[8].nil? || row[8].empty? ? row8 = nil : row8 = row[8].to_f
  data_positive_rate_json[:'data'].append(
    {
      "diagnosed_date": Time.parse(row[0]).iso8601,
      "positive_count": row[1].to_i,
      "negative_count": row[2].to_i,
      "pcr_positive_count": row[3].to_i,
      "antigen_positive_count": nil, # 未使用
      "pcr_negative_count": row[5].to_i,
      "antigen_negative_count": row6,
      "weekly_average_diagnosed_count": row7,
      "positive_rate": row8
    }
  )
end

######################################################################
# データ生成 テンプレート
# positive_status.json
######################################################################
data_positive_status_json = {
  'date': now.strftime('%Y/%m/%d %H:%M'),
  'data': []
}

######################################################################
# positive_status.json
# data の生成
######################################################################
# 岩手県が個別事例の退院日を公表してくれたら Google Sheets の
# input_検査陽性者の状況 と output_hospitalized_numbers が必要なくなり、
# 個別事例の退院日で自動計算できる。けど今はできないから Google Sheetsで管理する。
# https://github.com/MeditationDuck/covid19/issues/485
#
# (Date.new(2020, 2, 15)..Date.today).each do |date|
#   hospitalized_sum = 0
#   not_hospitalized_sum = 0
#
#   output_patients.values.each do |row|
#     if Date.parse(row[7]) <= date && row[8] == ""
#       # 入院日がその日より過去 かつ 退院日が空
#       # その日は入院中
#       hospitalized_sum += 1
#     elsif Date.parse(row[7]) <= date && Date.parse(row[8]) >= date
#       # 入院日がその日より過去 かつ 退院日がその日より未来
#       # その日は入院中
#       hospitalized_sum += 1
#     elsif Date.parse(row[7]) <= date && Date.parse(row[8]) < date
#       # 入院日がその日以降 かつ 退院日がその日より過去
#       # 退院した
#       not_hospitalized_sum += 1
#     end
#   end
#
#   data_positive_status_json[:'data'].append(
#     {
#       "date": date.strftime('%Y/%m/%d'),
#       "hospitalized": hospitalized_sum,
#       "severe_case": nil # SevereCaseCard.vue を使っていないので未使用
#     }
#   )
# end

output_hospitalized_numbers.values.each do |row|
  data_positive_status_json[:'data'].append(
    {
      "date": Time.parse(row[0]).iso8601,
      "hospitalized": row[2].to_i,
      "severe_case": nil # SevereCaseCard.vue を使っていないので未使用
    }
  )
end

######################################################################
# write json
######################################################################

File.open(File.join(__dir__, '../../data/', 'data.json'), 'w') do |f|
  f.write JSON.pretty_generate(data_json)
end

File.open(File.join(__dir__, '../../data/', 'patient_municipalities.json'), 'w') do |f|
  f.write JSON.pretty_generate(data_patient_municipalities_json)
end

File.open(File.join(__dir__, '../../data/', 'positive_by_diagnosed.json'), 'w') do |f|
  f.write JSON.pretty_generate(data_positive_by_diagnosed_json)
end

File.open(File.join(__dir__, '../../data/', 'daily_positive_detail.json'), 'w') do |f|
  f.write JSON.pretty_generate(data_daily_positive_detail_json)
end

File.open(File.join(__dir__, '../../data/', 'positive_rate.json'), 'w') do |f|
  f.write JSON.pretty_generate(data_positive_rate_json)
end

File.open(File.join(__dir__, '../../data/', 'positive_status.json'), 'w') do |f|
  f.write JSON.pretty_generate(data_positive_status_json)
end

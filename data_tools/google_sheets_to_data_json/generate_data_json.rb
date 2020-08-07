require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'json'
require 'time'
require 'date'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'.freeze
CREDENTIALS_PATH = 'credentials.json'.freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
TOKEN_PATH = 'token.yaml'.freeze
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or initiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
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

######################################################################
# Google Sheets から データ取得
######################################################################
SPREADSHEET_ID = '1VjxD8YTwEngvkfYOLD-4JG1tA5AnzTlgnzDO1lkTlNc'.freeze

PATIENTS_RANGE = 'output_patients!A2:L'.freeze
output_patients = service.get_spreadsheet_values SPREADSHEET_ID, PATIENTS_RANGE
raise if output_patients.values.empty?

INSPECTIONS_RANGE = 'input_検査件数!A2:F'.freeze
output_inspections = service.get_spreadsheet_values SPREADSHEET_ID, INSPECTIONS_RANGE
raise if output_inspections.values.empty?

CONTACTS_RANGE = 'input_帰国者接触者_相談件数!A2:E'.freeze
output_contacts = service.get_spreadsheet_values SPREADSHEET_ID, CONTACTS_RANGE
raise if output_contacts.values.empty?

QUERENTS_RANGE = 'input_一般_相談件数!A2:E'.freeze
output_querents = service.get_spreadsheet_values SPREADSHEET_ID, QUERENTS_RANGE
raise if output_querents.values.empty?

PATIENT_MUNICIPALITIES_RANGE = 'output_patient_municipalities!A2:G'.freeze
output_patient_municipalities = service.get_spreadsheet_values SPREADSHEET_ID, PATIENT_MUNICIPALITIES_RANGE
raise if output_patient_municipalities.values.empty?


######################################################################
# データ生成 テンプレート
# data.json
######################################################################
now = Time.now
data_json = {
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
      '県内': [],
      'その他': []
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
                'attr': '重症',
                'value': 0
              },
              {
                'attr': '不明',
                'value': 0
              }
            ]
          },
          {
            'attr': '退院',
            'value': 0
          },
          {
            'attr': '死亡',
            'value': 0
          }
        ]
      }
    ]
  }
}

######################################################################
# patients
######################################################################
# 陽性者
# A: 0: id
# B: 1: リリース日
# C: 2: 陽性確定日
# D: 3: 年代
# E: 4: 性別
# F: 5: 居住地
# G: 6: 陽性者の状況
# H: 7: 退院日
# I: 8: url
# J: 9: 通番
# K:10: 退院
# L:11: 確定からの経過日数

output_patients.values.each do |row|
  data_json[:'patients'][:'data'].append(
    {
      'id': row[0].to_i,
      'リリース日': Time.parse(row[1]).iso8601,
      '通番': row[9],
      '年代': row[3],
      '性別': row[4],
      '居住地': row[5],
      '退院': row[10] != '' ? row[10] : nil,
      'date': Time.parse(row[2]).strftime('%Y-%m-%d'),
      'url': row[8] != '' ? row[8] : nil,
    }
  )
end

######################################################################
# patients_summary
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
# inspections_summary
######################################################################
output_inspections.values.each do |row|
  data_json[:'inspections_summary'][:'data'][:'県内'].append row[4].to_i
  data_json[:'inspections_summary'][:'data'][:'その他'].append 0
  data_json[:'inspections_summary'][:'labels'].append Time.parse(row[0]).strftime('%-m/%d')
end


######################################################################
# main_summary
######################################################################
# 検査実施件数
inspection_sum = 0
output_inspections.values.each do |row|
  inspection_sum += row[5].to_i
end
data_json[:'main_summary'][:'value'] = inspection_sum

# 陽性患者数
data_json[:'main_summary'][:'children'][0][:'value'] = output_patients.values.size

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

msc0c = data_json[:'main_summary'][:'children'][0][:'children']
# 入院中
msc0c[0][:'value'] = patients_status[:'軽症・中等症'] + patients_status[:'重症']
# 軽症・中等症
msc0c[0][:'children'][0][:'value'] = patients_status[:'軽症・中等症']
# 重症
msc0c[0][:'children'][1][:'value'] = patients_status[:'重症']
# 不明
msc0c[0][:'children'][2][:'value'] = patients_status[:'入院・療養等調整中']
# 退院
msc0c[1][:'value'] = patients_status[:'退院等（要領期間経過も含む）']
# 死亡
msc0c[2][:'value'] = patients_status[:'死亡']


######################################################################
# データ生成 テンプレート
# data.antigen_tests_summary.json
######################################################################
data_antigen_tests_summary_json = {
  'antigen_tests_summary': {
    'date': now.strftime('%Y/%m/%d %H:%M'),
    'data': []
  }
}

######################################################################
# antigen_tests_summary
######################################################################
output_inspections.values.each do |row|
  data_antigen_tests_summary_json[:'antigen_tests_summary'][:'data'].append(
    {
      '日付': Time.parse(row[0]).iso8601,
      '抗原検査件数': row[3].to_i,
      '小計': row[3].to_i,
    }
  )
end


######################################################################
# データ生成 テンプレート
# data.contacts.json
######################################################################
data_contacts_json = {
  'contacts': {
    'date': now.strftime('%Y/%m/%d %H:%M'),
    'data': []
  }
}

######################################################################
# contacts
######################################################################
output_contacts.values.each do |row|
  data_contacts_json[:'contacts'][:'data'].append(
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
# data.querents.json
######################################################################
data_querents_json = {
  'querents': {
    'date': now.strftime('%Y/%m/%d %H:%M'),
    'data': []
  }
}

######################################################################
# querents
######################################################################
output_querents.values.each do |row|
  data_querents_json[:'querents'][:'data'].append(
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
# data.patient_municipalities
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
# write json
######################################################################

File.open(File.join(__dir__, '../../data/', 'data.json'), 'w') do |f|
  f.write JSON.pretty_generate(data_json)
end

File.open(File.join(__dir__, '../../data/', 'data.antigen_tests_summary.json'), 'w') do |f|
  f.write JSON.pretty_generate(data_antigen_tests_summary_json)
end

File.open(File.join(__dir__, '../../data/', 'data.contacts.json'), 'w') do |f|
  f.write JSON.pretty_generate(data_contacts_json)
end

File.open(File.join(__dir__, '../../data/', 'data.querents.json'), 'w') do |f|
  f.write JSON.pretty_generate(data_querents_json)
end

File.open(File.join(__dir__, '../../data/', 'patient_municipalities.json'), 'w') do |f|
  f.write JSON.pretty_generate(data_patient_municipalities_json)
end

# frozen_string_literal: true

require 'spec_helper'

def has_hospital_capacity_card(lang:, lang_json:)
  # h3
  expect(find('#HospitalCapacityCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq lang_json['HospitalCapacityCard']['title'].to_s
  d = find('#HospitalCapacityCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/hospital-capacity/"

  maxBeds = MAIN_SUMMARY_JSON['入院'] + MAIN_SUMMARY_JSON['調整中'] > 350 ? MAIN_SUMMARY_JSON['入院'] + MAIN_SUMMARY_JSON['調整中'] : 350

  maxBeds.times do |i|
    # 50ごとにspanに数字が書いてある
    if i % 50 == 49
      expect(find("#HospitalCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed:nth-child(#{i+1}) > span").text).to eq "#{i+1}"
    end

    # Bed 入院中
    if i < MAIN_SUMMARY_JSON['入院']
      expect(find("#HospitalCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed.inuse:nth-child(#{i+1})")[:title]).to eq "#{i+1}"
    end

    # Bed 調整中
    if i >= MAIN_SUMMARY_JSON['入院'] && i < MAIN_SUMMARY_JSON['入院'] + MAIN_SUMMARY_JSON['調整中']
      expect(find("#HospitalCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed.waiting:nth-child(#{i+1})")[:title]).to eq "#{i+1}"
    end

    # Beds 超過
    if i >= 350
      expect(find("#HospitalCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed.overflowed:nth-child(#{i+1})")[:title]).to eq "#{i+1}"
    end
  end

  # 凡例1
  expect(page).to have_selector('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(1) > span.Bed.inuse', count:1)
  expect(find('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(1)').text).to eq '入院中'
  expect(page).to have_selector('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(2) > span.Bed.waiting', count:1)
  expect(find('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(2)').text).to eq '入院療養等調整中'
  expect(page).to have_selector('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(3) > span.Bed', count:1)
  expect(find('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(3)').text).to eq '空き'

  # 凡例2
  expect(page).to have_selector('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(1) > span.Bed.phase2', count:1)
  expect(find('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(1)').text).to eq '実線枠はフェーズ2の確保病床 (軽中症220 + 重症30 = 250床)'
  expect(page).to have_selector('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(2) > span.Bed.phase3', count:1)
  expect(find('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(2)').text).to eq '点線枠はフェーズ3の確保病床 (軽中症305 + 重症45 = 350床)'

  if MAIN_SUMMARY_JSON['入院'] + MAIN_SUMMARY_JSON['調整中'] > 350
    expect(page).to have_selector('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(3) > span.Bed.overflowed', count:1)
    expect(find('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(3)').text).to eq '赤線枠はフェーズ3で確保予定の病床を超えた分'
  else
    expect(page).to have_selector('#HospitalCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(3) > span.Bed.overflowed', count:0)
  end
end

# frozen_string_literal: true

require 'spec_helper'

def has_hotel_capacity_card(lang:, lang_json:)
  # h3
  expect(find('#HotelCapacityCard > div > div > div.DataView-Header > div > div:nth-child(1) > h3').text).to eq lang_json['HotelCapacityCard']['title'].to_s
  d = find('#HotelCapacityCard > div > div > div.DataView-Header > div > div > h3 > a')[:href]
  lang_prefix = lang == :ja ? '' : "/#{lang}"
  expect(URI.parse(d).path).to eq "#{lang_prefix}/cards/hotel-capacity/"

  maxBeds = MAIN_SUMMARY_JSON['宿泊療養'] > 300 ? MAIN_SUMMARY_JSON['宿泊療養'] : 300

  maxBeds.times do |i|
    # 50ごとにspanに数字が書いてある
    if i % 50 == 49
      expect(find("#HotelCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed:nth-child(#{i+1}) > span").text).to eq "#{i+1}"
    end

    # Bed 療養中
    if i < MAIN_SUMMARY_JSON['宿泊療養']
      expect(find("#HotelCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed.inuse:nth-child(#{i+1})")[:title]).to eq "#{i+1}"
    end

    # Beds 超過
    if i >= 300
      expect(find("#HotelCapacityCard > div > div > div.DataView-Content > div.Beds > div.Bed.overflowed:nth-child(#{i+1})")[:title]).to eq "#{i+1}"
    end
  end

  # 凡例1
  expect(page).to have_selector('#HotelCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(1) > span.Bed.inuse', count:1)
  expect(find('#HotelCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(1)').text).to eq lang_json['HotelCapacityCard']['療養中']
  expect(page).to have_selector('#HotelCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(2) > span.Bed', count:1)
  expect(find('#HotelCapacityCard > div > div > div.DataView-Content > div.legend1 > div:nth-child(2)').text).to eq lang_json['HotelCapacityCard']['空き']

  # 凡例2
  expect(page).to have_selector('#HotelCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(1) > span.Bed.phase2', count:1)
  expect(find('#HotelCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(1)').text).to eq lang_json['HotelCapacityCard']['phase2']
  expect(page).to have_selector('#HotelCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(2) > span.Bed.phase3', count:1)
  expect(find('#HotelCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(2)').text).to eq lang_json['HotelCapacityCard']['phase3']

  if MAIN_SUMMARY_JSON['宿泊療養'] > 300
    expect(page).to have_selector('#HotelCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(3) > span.Bed.overflowed', count:1)
    expect(find('#HotelCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(3)').text).to eq lang_json['HotelCapacityCard']['overflowed']
  else
    expect(page).to have_selector('#HotelCapacityCard > div > div > div.DataView-Content > div.legend2 > div:nth-child(3) > span.Bed.overflowed', count:0)
  end
end

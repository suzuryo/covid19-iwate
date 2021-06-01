# frozen_string_literal: true

require 'spec_helper'

def has_page_header(lang:, data:)
  lang_json = data[:json]

  expect(page).to have_selector '#app.app > div > div.appContainer > main.mainContainer > div.container > div > div.PageHeader.mb-3'

  # h2
  expect(find('.PageHeader > h2.PageTitle').text).to eq lang_json['Common']['岩手の最新感染動向'].to_s
  expect(page).to have_selector('.PageHeader > h2.PageTitle span.v-icon svg')

  # UpdatedAt
  expect(find('.PageHeader > .UpdatedAt > span').text).to eq lang_json['SiteTopUpper']['最終更新'].to_s

  if lang == :ja
    # time
    expect(find('.PageHeader > div.UpdatedAt > time').text).to eq Time.parse(DATA_JSON['lastUpdate']).strftime('%Y年%-m月%-d日 %-H:%M JST')
    # Annotation
    expect(page).not_to have_selector('.PageHeader > .Annotation')
  else
    # time
    expect(find('.PageHeader.mb-3 > div.UpdatedAt > time').text).to eq Time.parse(DATA_JSON['lastUpdate']).strftime('%b %-d, %Y, %H:%M JST')
    # Annotation
    expect(find('.PageHeader > .Annotation > span').text).to eq lang_json['SiteTopUpper']['注釈'].to_s
  end
end

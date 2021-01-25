# frozen_string_literal: true

require 'spec_helper'

def has_breadcrumbs(id:, title:)
  # cards の 個別ページでは breadcrumbs が表示される
  expect(page).to have_selector("#{id} nav ul.v-breadcrumbs")
  expect(find("#{id} > nav > ul.v-breadcrumbs > li:nth-child(1) > a").text).to eq JA_JSON['Common']['ホーム']
  expect(find("#{id} > nav > ul.v-breadcrumbs > li:nth-child(3) > a").text).to eq title
end

def has_no_breadcrumbs(id:)
  expect(page).not_to have_selector("#{id} nav ul.v-breadcrumbs")
end

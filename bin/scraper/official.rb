#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class Member < Scraped::HTML
  field :name do
    MemberList::Member::Name.new(
      full:     fullname,
      prefixes: %w[Hon. Dr. the Honourable]
    ).short
  end

  field :position do
    noko.css('h3.elementor-image-box-title').map(&:text).map(&:tidy).first
  end

  field :url do
    noko.xpath('//link[@rel="canonical"]/@href').text
  end

  private

  def fullname
    noko.css('p.elementor-image-box-description').map(&:text).map(&:tidy).first
  end
end

dir = Pathname.new 'mirror'
data = dir.glob('*.html').sort.flat_map do |file|
  request = Scraped::Request.new(url: file, strategies: [LocalFileRequest])
  data = Member.new(response: request.response).to_h
  [data.delete(:position)].flatten.map { |posn| data.merge(position: posn) }
end.uniq

ORDER = %i[name position url].freeze
puts ORDER.to_csv
data.each { |row| puts row.values_at(*ORDER).to_csv }

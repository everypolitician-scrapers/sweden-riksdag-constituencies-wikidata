#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'scraperwiki'
require 'wikidata/fetcher'
require 'wikidata/area'

query = <<~SPARQL
  SELECT DISTINCT ?item WHERE {
    ?person p:P39 [ ps:P39/wdt:P279* wd:Q10655178 ; pq:P768 ?item ].
    ?item wdt:P31 wd:Q192611 .
  }
SPARQL

wanted = EveryPolitician::Wikidata.sparql(query)
raise 'No ids' if wanted.empty?

data = Wikidata::Areas.new(ids: wanted).data
ScraperWiki.sqliteexecute('DROP TABLE data') rescue nil
ScraperWiki.save_sqlite(%i(id), data)

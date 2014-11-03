require 'csv'
class NikkeiController < ApplicationController
  API_END_POINT = 'http://k-db.com/indices/I101'
  QUERIES = [ '?download=csv',
              '?year=2014&download=csv',
              '?year=2013&download=csv',
              '?year=2012&download=csv',
              '?year=2011&download=csv',
              '?year=2010&download=csv',
              '?year=2009&download=csv',
              '?year=2008&download=csv',
              '?year=2007&download=csv',
  ]

  def all
    cli = Faraday.new(:url => API_END_POINT)
    rows = QUERIES.each_with_object([]) do |query, ary|
      ary << cli.get(query).body.split("\r\n")[3..-1] # 3行目からデータなので、そこから取得
    end.flatten.uniq

    rows_csv = CSV.generate do |csv|
      rows.each { |row| csv << row.split(',') }
    end
    send_data rows_csv, type: 'text/csv; charset=shift_jis', filename: "nikkei.csv"
  end
end

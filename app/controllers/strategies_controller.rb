class StrategiesController < ApplicationController
  def index
  end

  def show
    require 'csv'
    @adj_close = []
    @ind1 = []
    @ind2 = []
    @volume = []
    @position_fill = []
    @daily_rets = []
    @transactions = []

    csv = CSV.read( Rails.root.join('demo', 'mktdata.csv') )
    csv.shift
    csv.each do |r|
      datetime = Date.parse r[0]
      @adj_close << {
        datetime: datetime,
        value: r[6].to_f
      }

      @ind1 << {
        datetime: datetime,
        value: r[7].to_f
      }

      @ind2 << {
        datetime: datetime,
        value: r[8].to_f
      }

      @volume << {
        datetime: datetime,
        value: r[5].to_i
      }
    end

    csv2 = CSV.read( Rails.root.join('demo', 'txndata.csv') )
    csv2.shift
    csv2.each_with_index do |r, i|
      datetime = Date.parse r[0]
      prev = i - 1
      @position_fill << {
        datetime: datetime,
        value: prev >= 0 ? (@position_fill[prev][:value] + r[1].to_i) : r[1].to_i
      }
      @transactions << {
        datetime: datetime,
        volume: r[1].to_i,
        price: r[2].to_f,
        fees: r[3].to_f,
        value: r[4].to_f,
        avg_cost: r[5].to_f,
        realized_pl: r[6].to_f
      }
    end

    csv3 = CSV.read( Rails.root.join('demo', 'retsdata.csv') )
    csv3.shift
    csv3.each_with_index do |r, i|
      datetime = Date.parse r[0]
      @daily_rets << {
        datetime: datetime,
        value: r[1].to_f
      }
    end
  end
end

# -*- coding: utf-8 -*-
require 'millionaire'
require 'millionaire/column'
require 'millionaire/validations/csv_uniqness'

module Millionaire::Csv
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    class_attribute :csv_data, :columns, :indexes
    attr_accessor :line_no

    self.columns = []
    self.indexes = {}
  end

  def initialize(attr={})
    attr.each {|k,v| send("#{k}=", v) }
  end

  module ClassMethods
    def load(io)
      self.csv_data = []
      csv = ::CSV.new(io, headers: :first_row, return_headers: false)
      csv.each_with_index do |row,ix|
        self.csv_data << self.new(row.to_hash.slice(*self.column_names).merge(line_no: ix.succ))
      end
      indexing
    end

    def column(name, option={})
      attr_accessor name
      column = Millionaire::Column.new(name, option)
      self.columns << column
      option.each do |k,v|
        case k
        when :null; validates name, presence: v unless v
        when :length; validates name, length: {maximum: v}
        when :value; validates name, inclusion: {in: v}
        when :constraint; validates name, v
        when :index; index(name)
        when :uniq
          validates name, csv_uniqness: v
          index(name)
        end
      end
    end
    def column_names; self.columns.map(&:name); end

    def index(*name)
      name.each do |n|
        self.indexes[Array.wrap n]  = []
      end
    end

    def indexing
      self.indexes.keys.each do |k|
        index_data= self.csv_data.group_by do |v|
          k.map{|a| v.send(a) }
        end
        self.indexes[k] = index_data
      end
    end

    def where(query)
      if self.indexes.key? query.keys
        self.indexes[query.keys][query.values]
      else
        group = self.csv_data.group_by do |r|
          query.map{|k,v| r.send(k)}
        end

        if query.values.all? {|val| val.is_a? Array }
          query.values.map {|val| val.map {|v| group[Array.wrap(v)] } }.flatten
        else
          group[query.values]
        end
      end
    end

    def find(line_no)
      csv_data[line_no.pred]
    end
    def all; self.csv_data; end
    def first; self.csv_data.first; end
    def last; self.csv_data.last; end
  end
end

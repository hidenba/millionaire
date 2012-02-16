# -*- coding: utf-8 -*-
require 'millionaire'
require 'millionaire/column'
require 'millionaire/validations/csv_uniqness'

module Millionaire::Base
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    class_attribute :csv_data, :columns, :indexes
    self.columns = []
    self.indexes = {}
  end

  def initialize(attr={})
    attr.each {|k,v| send("#{k}=", v) }
  end

  module ClassMethods
    def column(name, option={})
      attr_accessor name
      column = Millionaire::Column.new(name, option)
      self.columns << column
      option.each do |k,v|
        case k
        when :null; validates name, presence: true unless v
        when :length; validates name, length: {maximum: v}
        when :value; validates name, inclusion: {in: v}
        when :constraint; validates name, v
        when :index; self.indexes[name.to_s] = []
        when :uniq;
          validates name, csv_uniqness: column.uniq_key
          self.indexes[column.uniq_key] = []
        end
      end
    end

    def index(*name)
      name.each do |n|
        self.indexes[n.is_a?(Array) ? n.map(&:to_s).join('_') : n.to_s]  = []
      end
    end

    def load(io)
      self.csv_data = []
      csv = ::CSV.new(io, headers: :first_row, return_headers: false)
      csv.each do |row|
        self.csv_data << self.new(row.to_hash.slice(*self.column_names))
      end

      self.indexes[uniqness] = [] if uniqness.present?
      self.indexes.keys.each do |k|
        self.indexes[k] = self.csv_data.group_by{|v| v.send(k) }
      end
    end

    def all; self.csv_data; end
    def columns; self.columns; end
    def column_names; self.columns.map(&:name); end
    def indexes; self.indexes; end
  end
end

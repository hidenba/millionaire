# -*- coding: utf-8 -*-
require 'millionaire'
require 'millionaire/column'

module Millionaire::Base
  extend ActiveSupport::Concern
  include ActiveModel::Validations

  included do
    class_attribute :csv_data, :columns
    self.columns = []
  end

  def initialize(attr={})
    attr.each {|k,v| send("#{k}=", v) }
  end

  module ClassMethods
    def column(name, option={})
      attr_accessor name
      self.columns << Millionaire::Column.new(name)
      option.each do |k,v|
        case k
        when :null; validates name, presence: true unless v
        when :length; validates name, length: {maximum: v}
        when :value; validates name, inclusion: {in: v}
        when :constraint; validates name, v
        end
      end
    end

    def load(io)
      self.csv_data = []
      csv = ::CSV.new(io, headers: :first_row, return_headers: false)
      csv.each do |row|
        self.csv_data << self.new(row.to_hash.slice(*self.column_names))
      end
    end

    def all; self.csv_data; end
    def columns; self.columns; end
    def column_names; self.columns.map(&:name); end
  end
end

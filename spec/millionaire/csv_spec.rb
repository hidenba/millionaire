# -*- coding: utf-8 -*-
require 'spec_helper'
require 'millionaire/csv'

describe Millionaire::Csv do
  class CsvRecord
    include Millionaire::Csv
    column :str, index: true
  end

  describe '.column' do
    class Column
      include Millionaire::Csv
      column :index , index: true
      column :presence, null: false, index: true
      column :length, length: 20
      column :inclution, value: %w(foo bar)
      column :constraint, constraint: {format: {with: /\A[a-zA-Z]+\z/}}
      column :int, integer: true, value: 100..200
      column :uniq1, uniq: [:index]
    end

    subject { Column.new }
    it { Column.column_names.each {|name| should respond_to name } }

    context 'column validation' do
      subject { Column.validators.index_by {|v| v.attributes.first } }
      its([:presence]) { should be_kind_of ActiveModel::Validations::PresenceValidator }
      its([:length]) { should be_kind_of ActiveModel::Validations::LengthValidator }
      its([:inclution]) { should be_kind_of ActiveModel::Validations::InclusionValidator }
      its([:constraint]) { should be_kind_of ActiveModel::Validations::FormatValidator }
      its([:int]) { should be_kind_of ActiveModel::Validations::InclusionValidator }
      its([:uniq1]) { should be_kind_of CsvUniqnessValidator }
    end
  end

  describe 'index' do
    class Index
      include Millionaire::Csv
      column :index_a
      column :index_b
      index :index_a, :index_b
      index [:index_a, :index_b]
    end

    subject { Index.indexes }
    its(:keys) { should  =~ [[:index_a], [:index_b], [:index_a, :index_b]] }

    describe '.indexing' do
      before do
        Index.csv_data=[Index.new(index_a: 10, index_b: 20)]
        Index.indexing
      end

      its([[:index_a]]) { should have(1).record }
      its([[:index_b]]) {  should have(1).record }
      its([[:index_a, :index_b]]) {  should have(1).record }
    end
  end

  describe '.all' do
    let(:io) { StringIO.new %w(str foo bar).join("\n") }

    before do
      CsvRecord.load io
    end

    subject { CsvRecord.all }
    it { should have(2).recoed }

    context 'load csv' do
      subject { CsvRecord.all.first }
      its(:line_no) { should == 1 }
      its(:str) { should == 'foo' }
    end
  end

  describe '.find' do
    before do
      CsvRecord.load StringIO.new %w(str alice bob chris).join("\n")
    end

    subject { CsvRecord.find line_no }
    let(:line_no) { 2 }
    its(:str) { should == 'bob' }

    context 'recoed not found' do
      let(:line_no) { 100 }
      it { should be_nil }
    end
  end

  describe '.where' do
    class Where
      include Millionaire::Csv
      column :str_a
      column :str_b
      column :str_c
      index [:str_b, :str_c]
    end

    before do
      Where.load StringIO.new %w(str_a,str_b,str_c 1,2,3 2,1,3 3,1,2).join("\n")
    end

    context 'no index' do
      subject { Where.where(str_a: '1', str_b: '2').first }
      its(:line_no) { should == 1 }
    end

    context 'has index' do
      subject { Where.where(str_b: '1', str_c: '2').first }
      its(:line_no) { should == 3 }
    end
  end
end

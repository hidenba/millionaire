# -*- coding: utf-8 -*-
require 'spec_helper'
require 'millionaire/csv'

describe Millionaire::Csv do
  describe '.column' do
    class CsvLoad
      include Millionaire::Csv
      column :index , index: true
      column :presence, null: false, index: true
      column :length, length: 20
      column :inclution, value: %w(foo bar)
      column :constraint, constraint: {format: {with: /\A[a-zA-Z]+\z/}}
      column :int, integer: true, value: 100..200
      column :uniq1, uniq: [:index]
    end

    subject { CsvLoad.new }
    it 'カラムが定義されている' do
      CsvLoad.column_names.each {|name| should respond_to name }
    end

    context 'カラムの制約を設定できる' do
      subject { CsvLoad.validators.index_by {|v| v.attributes.first } }
      its([:presence]) { should be_kind_of ActiveModel::Validations::PresenceValidator }
      its([:length]) { should be_kind_of ActiveModel::Validations::LengthValidator }
      its([:inclution]) { should be_kind_of ActiveModel::Validations::InclusionValidator }
      its([:constraint]) { should be_kind_of ActiveModel::Validations::FormatValidator }
      its([:int]) { should be_kind_of ActiveModel::Validations::InclusionValidator }
      its([:uniq1]) { should be_kind_of CsvUniqnessValidator }
    end

    context 'インデックスが設定できる' do
      subject { CsvLoad.indexes }
      its(:keys) { should  =~ ['index', 'presence', 'uniq1_index'] }
    end

  end

  describe '.index' do
    class Index
      include Millionaire::Csv
      column :index_a
      column :index_b
      index :index_a, :index_b
      index [:index_a, :index_b]
    end

    subject { Index.indexes }
    its(:keys) { should  =~ ['index_a', 'index_b', 'index_a_index_b'] }
  end

  describe '.all' do
    class AllLoad
      include Millionaire::Csv
      column :str, index: true
    end

    let(:io) { StringIO.new %w(str foo bar).join("\n") }

    before do
      AllLoad.load io
    end

    subject { AllLoad.all }
    it { should have(2).recoed }

    context '設定したカラムに値が入っている' do
      subject { AllLoad.all.first }
      its(:str) { should == 'foo' }
    end

    context 'インデックスが作成されている' do
      subject { AllLoad.indexes['str'] }
      its(['foo']) { should have(1).record }
    end
  end
end

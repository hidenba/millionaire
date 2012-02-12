# -*- coding: utf-8 -*-
require 'spec_helper'
require 'millionaire/base'

describe Millionaire::Base do
  describe '.column' do
    class CsvLoad
      include Millionaire::Base
      column :presence, null: false
      column :length, length: 20
      column :inclution, value: %w(foo bar)
      column :constraint, constraint: {format: {with: /\A[a-zA-Z]+\z/}}
      column :int, integer: true, value: 100..200
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
    end
  end

  describe '.all' do
    class CsvLoad
      include Millionaire::Base
      column :str
    end

    let(:io) { StringIO.new %w(str foo bar).join("\n") }

    before do
      CsvLoad.load io
    end

    subject { CsvLoad.all }
    it { should have(2).recoed }

    context '設定したカラムに値が入っている' do
      subject { CsvLoad.all.first }
      its(:str) { should == 'foo' }
    end
  end
end

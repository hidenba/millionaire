# -*- coding: utf-8 -*-
require 'spec_helper'
require 'millionaire/csv'

describe Millionaire::Csv do

  describe 'single column' do
    class Single
      include Millionaire::Csv
      column :str, uniq: true
    end

    before do
      Single.load StringIO.new csv_data.join("\n")
      Single.first.valid?
    end

    subject { Single.first.errors }

    context 'valid' do
      let(:csv_data) { %w(str alice bob chris) }
      it { should be_blank }
    end

    context 'invalid' do
      let(:csv_data) { %w(str alice bob alice) }
      it { should be_present }
      its([:str]) { should == ['already exists'] }
    end
  end
end

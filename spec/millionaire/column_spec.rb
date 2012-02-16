# -*- coding: utf-8 -*-
require 'spec_helper'
require 'millionaire/column'

describe Millionaire::Column do
  let(:column) { Millionaire::Column.new 'name', option }
  describe '#uniq_key' do
    let(:option) { {uniq: true} }
    subject { column.uniq_key }

    context '単一キー' do
      it { should == 'name' }
    end

    context '複合キー' do
      let(:option) { {uniq: [:hoge, :fuga]} }
      it { should == 'name_hoge_fuga' }
    end
  end
end

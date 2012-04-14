# -*- coding: utf-8 -*-
require 'millionaire'

class Millionaire::Column
  attr_accessor :name, :uniq

  def initialize(name, option)
    @name = name.to_s
    @uniq = option[:uniq]
    @option = option
  end
end

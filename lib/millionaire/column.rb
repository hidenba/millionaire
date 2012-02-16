# -*- coding: utf-8 -*-

class Millionaire::Column
  attr_accessor :name, :uniq

  def initialize(name, option)
    @name = name.to_s
    @uniq = option[:uniq]
    @option = option
  end

  def uniq_key
    uniq.is_a?(Array) ? [name, *uniq].join('_') : name
  end
end

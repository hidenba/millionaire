# -*- coding: utf-8 -*-

class Millionaire::Column
  attr_accessor :name

  def initialize(name)
    @name = name.to_s
  end
end

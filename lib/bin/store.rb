# encoding: UTF-8
module Bin
  class Store < ActiveSupport::Cache::Store
    attr_reader :database

    def initialize(database)
      @database = database
    end
  end
end
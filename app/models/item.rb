# coding:utf-8
require_relative 'mongo_model'

class Item < MongoModel

  def initialize
    super
    set_collection(:item)
  end

end

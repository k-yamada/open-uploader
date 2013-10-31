# coding:utf-8
#require_relative 'mongo_model'

class Item# < MongoModel
  include MongoMapper::Document

  key :name, String
  key :content_type, String
  key :original_filename, String
  key :file_data, Binary
  timestamps!


#  def initialize
#    super
#    set_collection(:item)
#  end

end

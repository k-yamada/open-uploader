# coding:utf-8
require 'mongo'

# Usage
# -------------
# update                 - 全てのフィールドを書き換える
# update($setオプション) - 指定されたフィールドのみ更新

class MongoModel
  attr_accessor :coll

  @@hosts       = $config[:mongo_host] || ["localhost:27017"]
  @@dbname      = $config[:mongo_dbname]
  @@conn        = nil
  @@db          = nil

  class << self
    def dbname
      @@dbname
    end

    def dbname=(val)
      @@dbname = val
    end

    def mongoencode(str)
      str.gsub!('.', '#1#')
      str.gsub!('$', '#2#')
      str
    end

    def mongodecode(str)
      str.gsub!('#1#', '.')
      str.gsub!('#2#', '$')
      str
    end
  end

  def initialize()
    if @@conn == nil
      if @@hosts.length > 1
        @@conn = Mongo::MongoReplicaSetClient.new(@@hosts)
        # @@conn = Mongo::MongoReplicaSetClient.new(@@hosts, :read => :secondary)
      else
        host, port = @@hosts[0].split(":")
        @@conn = Mongo::Connection.new(host, port)
      end
      @@db   = @@conn.db(@@dbname)
    end
  end

  def set_collection(coll_name)
    @coll = @@db.collection(coll_name)
  end

  def update_set(criteria, new_object)
    @coll.update(criteria, {'$set' => new_object})
  end

  def upsert(criteria, new_object)
    @coll.update(criteria, new_object, {:upsert => true})
  end

  def upsert_set(criteria, new_object)
    @coll.update(criteria, {'$set' => new_object}, {:upsert => true})
  end

  def get_oid(id)
    if id.class == String
      BSON::ObjectId(id)
    else
      id
    end
  end

  def find_by_id(id)
    oid = get_oid(id)
    find_one({:_id => oid})
  end

  def update_by_id(id, new_object)
    oid = get_oid(id)
    criteria = {:_id => oid}
    update(criteria, new_object)
  end

  def update_set_by_id(id, new_object)
    oid = get_oid(id)
    criteria = {:_id => oid}
    update_set(criteria, new_object)
  end

  def upsert_by_id(id, new_object)
    oid = get_oid(id)
    criteria = {:_id => oid}
    upsert(criteria, new_object)
  end

  def upsert_set_by_id(id, new_object)
    oid = get_oid(id)
    criteria = {:_id => oid}
    upsert_set(criteria, new_object)
  end

  def remove_by_id(id)
    oid = get_oid(id)
    remove({:_id => oid})
  end

  def find_by_param(field, value)
    find({field => value})
  end

  def find_one_by_param(field, value)
    find_one({field => value})
  end

  def method_missing(name, *args)
    return find_by_param($1.to_sym, args[0]) if name.to_s =~ /^find_by_(.*)/
    return find_one_by_param($1.to_sym, args[0]) if name.to_s =~ /^find_one_by_(.*)/
    @coll.send(name, *args)
  end

  def create_grid()
    Mongo::Grid.new(@@db)
  end
end

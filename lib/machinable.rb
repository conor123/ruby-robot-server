module Machinable
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :state, String

  validates_presence_of :name
  validates_presence_of :state
end
class Robot
    include DataMapper::Resource

    property :id, Serial
    property :name, String
    property :state, String
    property :pid, String

    validates_presence_of :name
    validates_presence_of :state
end 

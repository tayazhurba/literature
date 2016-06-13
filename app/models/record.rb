class Record < ActiveRecord::Base

belongs_to :list
has_many :fields

end

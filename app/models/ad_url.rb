class AdUrl < ActiveRecord::Base
	belongs_to :keyword
	self.per_page = 20
end

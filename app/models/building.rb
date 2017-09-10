class Building < ActiveRecord::Base
  belongs_to :project
  has_many :floors
end

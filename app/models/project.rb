class Project < ActiveRecord::Base
  belongs_to :customer
  has_many :buildings

  validates_presence_of :name
  validates_presence_of :customer

  def to_s
    name
  end

  def tag
    Tag.find tag_id if tag_id
  end
end

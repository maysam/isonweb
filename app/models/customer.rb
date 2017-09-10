class Customer < ActiveRecord::Base
  belongs_to :admin_user
  has_many :projects
  # has_many :buildings, through: :projects, :autosave => false

  validates_presence_of :name

  validates_presence_of :email
  validates_uniqueness_of :email

  validates_presence_of :admin_user
end

class AdminUser < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :customers
  has_many :projects, through: :customers

  def all_tags
    Tag.all
  end

  def all_floors
    if super_admin?
      Floor.all
    else
      bs = all_buildings.map{ |e| e.floors.pluck :id }.flatten
      Floor.where id: bs
    end
  end

  def all_buildings
    if super_admin?
      Building.all
    else
      bs = all_projects.map{ |e| e.buildings.pluck :id }.flatten
      Building.where id: bs
    end
  end

  def all_projects
    if super_admin?
      Projects.all
    else
      projects
    end
  end

  def all_admin_users
    if super_admin?
      AdminUser.all
    else
      AdminUser.where id: id
    end
  end

  def self.recent(count)
    AdminUser.last count
  end
end

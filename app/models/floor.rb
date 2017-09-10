class Floor < ActiveRecord::Base
  has_many :tags
  belongs_to :building
  has_attached_file :plan,
    styles: {
      thumb: ["100x100>", :png],
      small: ["150x150>", :png],
      medium: ["600x600>", :png],
      big: ["1000x1000>", :png],
      actual: ["10000x10000>", :png]
    }
  do_not_validate_attachment_file_type :plan

  def url
      plan.url(:actual)
  end
end

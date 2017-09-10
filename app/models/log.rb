class Log < ActiveRecord::Base
  belongs_to :tag
  belongs_to :reading
  default_scope { order('datetime ASC') }
end

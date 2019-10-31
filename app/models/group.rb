class Group < ApplicationRecord
  has_many :groupuserlookups
  has_many :users, through: :groupuserlookups

end

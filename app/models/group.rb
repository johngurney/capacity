class Group < ApplicationRecord
  has_many :groupuserlookups
  has_many :users, through: :groupuserlookups

  has_many :departments
  has_many :areas

end

class Area < ApplicationRecord
  has_and_belongs_to_many :users
  belongs_to :group
end

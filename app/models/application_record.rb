class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def test
    "test123"
  end
end

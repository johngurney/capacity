class Capacitylog < ApplicationRecord
  def text
    code = Capacitycode.where(:capacity_number => self.capacity_number).first
    if code.present?
      code.text
    else
      ""
    end
  end
end

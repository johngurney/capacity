class Capacitylog < ApplicationRecord
  def text
    code = Capacitycode.where(:capacity_number => self.capacity_number).first

    if code.present?
      return code.text, (code.alert ? "red" : "black")
    else
      return "", "black"
    end
  end

end

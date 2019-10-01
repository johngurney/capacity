class User < ApplicationRecord
  has_and_belongs_to_many :areas
  def name
    self.first_name + " " + self.last_name
  end

  def login

    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
    token = (0...16).map { o[SecureRandom.random_number(o.length)] }.join
    log = Loginlog.create(:user_id => self.id, :token => token)
    log.save
    token

  end

  def capacity_log
    logs = Capacitylog.where(:user_id => self.id).order(:created_at)
    return logs.last if logs.count > 0

  end
end

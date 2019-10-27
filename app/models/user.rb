class User < ApplicationRecord
  has_and_belongs_to_many :areas
  belongs_to :department, optional: true
  belongs_to :location, optional: true

  def name
    self.first_name.to_s + " " + self.last_name.to_s
  end

  def login

    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
    token = (0...16).map { o[SecureRandom.random_number(o.length)] }.join
    log = Loginlog.create(:user_id => self.id, :token => token)
    log.save
    token

  end

  def check_search_criteria(included_areas, included_departments, included_locations)

    if !included_areas.blank?
      flag = false
      included_areas.each do |area_id|
        if self.areas.include?(Area.find(area_id))
          flag = true
          break
        end
      end
      return false if !flag
    end

    if !included_departments.blank?
      flag = false
      included_departments.each do |department_id|
        if !self.department.blank? && self.department.id == department_id
          flag = true
          break
        end
      end
      return false if !flag
    end

    if !included_locations.blank?
      flag = false
      included_locations.each do |location_id|
        if !self.location.blank? && self.location.id == location_id
          flag = true
          break
        end
      end
      return false if !flag
    end

    return true

  end

  def capacity_log
    logs = Capacitylog.where(:user_id => self.id).order(:created_at)
    return logs.last if logs.count > 0

  end

  def department_name
    self.department.blank? ? "" : self.department.name
  end

  def location_name
    self.location.blank? ? "" : self.location.name
  end

  def department_id
    self.department.blank? ? 0 : self.department.id
  end

  def location_id
    self.location.blank? ? 0 : self.location.id
  end

  def make_password
    prng = Random.new
    self.password = Location.all.limit(1).offset(prng.rand(Location.all.count)).first.name + prng.rand(9999).to_i.to_s
    puts "&&&&&&: " + self.password
    self.save(:validate => false)
  end

  def capacity_ys
    end_date = Time.now
    start_date = 1.years.ago
    puts start_date.to_s
    stg = ""

    puts "%%%%" + Capacitylog.where(:user_id => self.id).where("created_at >= ?", start_date).count.to_s

    Capacitylog.where(:user_id => self.id).where("created_at >= ? AND created_at < ?", start_date, end_date).order(:created_at).each do |log|
      stg += ", " if stg != ""
      stg += log.capacity_number.to_s
    end
    stg

  end

  def capacity_xs
    end_date = Time.now
    start_date = 1.years.ago
    stg = ""
    Capacitylog.where(:user_id => self.id).where("created_at >= ? AND created_at < ?", start_date, end_date).order(:created_at).each do |log|
      stg += ", " if stg != ""
      a = (log.created_at - start_date)
      b = (end_date - start_date)
      stg += ((log.created_at - start_date) / (end_date - start_date)).to_s
    end
    stg

  end

  def average_capacity

    if Capacitylog.where(:user_id => self.id).count > 0

      end_date = Time.now
      start_date = 1.years.ago
      log = Capacitylog.where(:user_id => self.id).where("created_at < ?", end_date).order(:created_at).last
      capacity_number = 0

      if log.blank?
        log = Capacitylog.where(:user_id => self.id).order(:created_at).first
        start_date = log.created_at
      end

      capacity_number = log.capacity_number
      t = 0
      date = start_date

      Capacitylog.where(:user_id => self.id).where("created_at >= ? AND created_at < ?", start_date, end_date).order(:created_at).each do |log|
        t += ( log.created_at - date ) * capacity_number
        date = log.created_at
        capacity_number = log.capacity_number
      end

      t+= (end_date - date) * capacity_number

      (t / (end_date - start_date)).round(2)
    else
      0
    end

  end

  def months
    number_of_months = 0..11
    stg = ""
    number_of_months.to_a.reverse.each do |month_offset|
      stg += ", " if stg != ""
      stg += "\"" + month_offset.months.ago.strftime("%b %y") + "\""
    end
    stg
  end

  def is_admin?
    !self.user_type.blank? && (self.user_type == "Administrator")
  end



end

class User < ApplicationRecord
  has_and_belongs_to_many :areas
  belongs_to :department, optional: true
  belongs_to :location, optional: true

  has_many :groupuserlookups
  has_many :groups, through: :groupuserlookups

  has_many :objectives

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

  def capacity_stg
    log = self.capacity_log
    puts "log =" + log.capacity_number.to_s
    log.capacity_number.to_s + ( log.comment.blank? || log.comment == "" ? "" : " - " + log.comment) if log.present?

  end

  def objective_stg
    objective = Objective.where(:user_id => self.id).order(:created_at)
    return objective.last.text.to_s if objective.count > 0
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
    self.save(:validate => false)
  end

  def capacity_ys(start_date, end_date)
    stg = ""

    Capacitylog.where(:user_id => self.id).where("created_at >= ? AND created_at < ?", start_date, end_date).order(:created_at).each do |log|
      stg += ", " if stg != ""
      stg += log.capacity_number.to_s
    end
    stg

  end



  def capacity_xs(start_date, end_date)
    stg = ""
    Capacitylog.where(:user_id => self.id).where("created_at >= ? AND created_at < ?", start_date, end_date).order(:created_at).each do |log|
      stg += ", " if stg != ""
      stg += ((log.created_at.to_datetime - start_date) / (end_date - start_date)).to_s
    end
    stg

  end

  def average_capacity(start_date, end_date)

    if Capacitylog.where(:user_id => self.id).count > 0

      puts "end_date" + end_date.to_s

      log = Capacitylog.where(:user_id => self.id).where("created_at < ?", start_date).order(:created_at).last

      if log.blank?
        log = Capacitylog.where(:user_id => self.id).order(:created_at).first
        first_log_date = log.created_at.to_datetime
      else
        first_log_date = start_date
      end

      if log.present?

        capacity_number = log.capacity_number

        total = 0
        date = first_log_date.to_datetime

        Capacitylog.where(:user_id => self.id).where("created_at >= ? AND created_at < ?", start_date, end_date).order(:created_at).each do |log|
          puts "total" + total.to_s
          total += ( log.created_at.to_datetime - date ) * capacity_number
          date = log.created_at.to_datetime
          capacity_number = log.capacity_number
        end


        total += (end_date - date) * capacity_number
        puts (end_date-start_date).to_s
        puts (first_log_date - start_date).to_s
        puts end_date.class.to_s
        puts first_log_date.class.to_s
        puts (end_date - first_log_date).to_s

        return (total / (end_date - first_log_date)).round(2).to_s + ", " + ((first_log_date - start_date)/(end_date-start_date)).to_s


      else
        "0, 0"
      end
      "0, 0"
    end

  end

  def is_admin?
    !self.user_type.blank? && (self.user_type == "Administrator")
  end

  def is_user?
    !self.user_type.blank? && (self.user_type == "User")
  end

  def history_start_date
    self[:history_start_date].present? ? self[:history_start_date] :  1.years.ago + 1.days
  end

  def history_end_date
    self[:history_end_date].present? ? self[:history_end_date] :  Date.today
  end

  def group_selected?(group)
    lookup =  Groupuserlookup.where(:user_id => self.id, :group_id => group.id).first
    lookup.present? ? lookup.selected : false
  end

  def first_selected_group
    #NB this should be called only by (a) the logged_on_user (b) which is an Administrator
    if self.groups.empty?
      #There should always be at least one group for the user, but this is just in case there isn't

      self.groups << Group.all.order(:name).first
      group = self.groups.first
      self.set_selected(group, true)
      group
    else
      self.groups.order(:name).each do |group|
        if self.selected(group)
          return group
        end
      end
    end
  end

  def groups_stg
    stg = ""
    self.groups.each do |group|
      stg += "; " if stg != ""
      stg += group.name
    end
    stg
  end

  def set_selected(group, value)
    lookups = Groupuserlookup.where(:user_id => self.id, :group_id => group.id)
    if lookups.empty?
      Groupuserlookup.create(:user_id => self.id, :group_id => group.id, :selected => true)
      return
    elsif logs.count > 1
      lookups.all[1..-1].delete_all if lookups.count > 1
    end
    lookup = lookups.first
    lookup.selected = value
    lookup.save
  end

  def selected(group)
    if self.groups.count == 1
      true
    else
      logs = Groupuserlookup.where(:user_id => self.id, :group_id => group.id)
      logs.first.selected if !logs.empty?
    end
  end


  def effective_groups
    if self.user_type == "Administrator"
      Group.all
    else
      self.groups
    end
  end

  def multi_selected_groups
    n = 0
    self.groups.each do |group|
      n +=1 if self.selected(group)
    end
    n > 1
  end

  def last_objective
    self.objectives.count == 0 ? "" : self.objectives.order(:created_at).last.text
  end

  def get_create_group_lookup(group)
    lookups = Groupuserlookup.where(:user_id => self.id, :group_id => group.id)

    if lookups.count == 0
      Groupuserlookup.create(:user_id => self.id, :group_id => group.id)
      return
    elsif lookups.count > 0
      #Delete all duplicate entries (ie those other than the first).  This is just housekeeping, it should never be required
      lookups.all[1..-1].delete_all if lookups.count > 1
    end
    lookups.first

  end

  def areas_of_selected_groups
    areas = []
    groups = self.effective_groups
    groups.order(:name).each do |group|
      if self.selected(group)
        group.areas.order(:name).each do |area|
          areas << area
        end
      end
    end
    areas
  end

  def depts_of_selected_groups
    depts = []
    groups = self.effective_groups
    groups.order(:name).each do |group|
      if self.selected(group)
        group.departments.order(:name).each do |dept|
          depts << dept
        end
      end
    end
    depts
  end

end

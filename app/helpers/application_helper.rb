module ApplicationHelper
  include ActionView::Helpers::FormTagHelper

  def get_all_ids(entries)
    stg=""
    entries.each do |record|
      stg += ", " if stg != ""
      stg += record.id.to_s
    end
    stg
  end

  def months(start_date, end_date)
    if end_date > start_date

      months_between = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month) + 1
      months_per_entry = (months_between.to_d / 12).ceil(0)

      date = start_date.beginning_of_month
      stg = ""
      while date < end_date do
        stg += ", " if stg != ""
        stg += "\"" + date.strftime("%b %y") + "\""
        (1..months_per_entry).each do
          date = date.next_month
        end
      end
      stg
    end
  end

  def all_capacity_ys(start_date, end_date)

  end

  def average_for_hash (hash)
    hash.blank? ? nil : hash.sum{|user_id, capacity_number| capacity_number}.to_d / hash.count.to_d
  end



  def all_capacity_xs_and_ys(start_date, end_date, users)

    test_stg = ""
    #
    users_last_number = {}
    leaving_dates = {}
    logs = []

    users.each do |user|
      leaving_date = user.leaving_date
      if leaving_date.blank? || leaving_date > start_date
        leaving_dates[user.id.to_s] = leaving_date if leaving_date.present? && leaving_date < end_date
        log = Capacitylog.where(:user_id => user.id).where("created_at <= ?", start_date).order(:created_at).last
        users_last_number[user.id.to_s] = log.capacity_number if log.present?

        logs.concat Capacitylog.where(:user_id => user.id).where("created_at >= ? AND created_at < ?", start_date, leaving_date.blank? || leaving_date >= end_date ? end_date : leaving_date)

      end

    end

    logs.sort_by! {|log| [ log[:created_at] ]}

    test_stg = logs.count.to_s

    log_dates =[]

    logs.each do |log|
      log_datetime = log.created_at.to_datetime
      log_dates << log_datetime if !log_dates.include?(log_datetime)
    end

    current_date = start_date
    xs_stg = ""
    ys_stg = ""
    number_of_users = []
    total = 0

    time_total = 0.0
    n = 0

    actual_start_date = nil

    log_dates.each do |date|
      xs_stg +=", " if xs_stg != ""
      ys_stg +=", " if ys_stg != ""
      avg = average_for_hash(users_last_number)
      if avg.present?
        actual_start_date = current_date if actual_start_date.blank?
        xs_stg += ((current_date - start_date).to_f / (end_date - start_date).to_f).round(4).to_s
        ys_stg += avg.round(4).to_s
        number_of_users << users_last_number.count

        total += (date - current_date).to_f * avg
      end

      n1 = 0


      logs.each do |log|
        break if n1> 100
        t= Time.now
        users_last_number[log.user_id.to_s] = log.capacity_number if log.created_at == date
        time_total += Time.now - t
        n+=1
        n1 += 1
      end

    #   leaving_dates.each do |user_id, leaving_date|
    #     if leaving_date < date
    #       users_last_number.delete(user_id)
    #       leaving_dates.delete(user_id)
    #     end
    #   end
    #
    #   current_date = date
    #
    #   puts "$$$" + date.to_s
    #
    end
    #
    # number_of_users_stg = ""
    # number_of_users.each do |n|
    #   number_of_users_stg +=", " if number_of_users_stg != ""
    #   number_of_users_stg += n.to_s
    # end
    #
    # actual_start_date = start_date if actual_start_date.blank?
    # return xs_stg, ys_stg, (total / (end_date - actual_start_date)).to_f.round(4).to_s, number_of_users_stg, number_of_users.max.to_s, graph_ticks(number_of_users.max)
    return "", "", "", "", "", "", (time_total / n.to_d).to_s
  end

  def graph_ticks(v)

    v = 1 if v.to_i < 1

    oom = Math.log10(v.to_d).floor
    v1 = v.to_d / (10 ** oom)
    stg = ""
    f = false
    if v1 <= 2
      (1..v1 * 2).each do |x|
        stg += ", " if stg !=""
        stg += (x.to_d / 2 * 10 ** oom).to_s
        f = (x / 2 == v1)
      end
      stg += ", " + v.to_s if !f

    elsif v1 <= 6
      (1..v1).each do |x|
        stg += ", " if stg != ""
        stg += (x * 10 ** oom).to_s
        f = (x == v1)
      end
      stg += ", " + v.to_s if !f

    else
      (1..v1/2).each do |x|
        stg += ", " if stg != ""
        stg += (x * 2 * 10 ** oom).to_s
        f = (x * 2 == v1)
      end
      stg += ", " + v.to_s if !f
    end
    stg

  end




end

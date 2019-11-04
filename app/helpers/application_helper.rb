module ApplicationHelper
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



  def all_capacity_xs(start_date, end_date)

  end

  def all_average_capacity(start_date, end_date)


  end



end

module ApplicationHelper
  def get_all_ids(database)
    stg=""
    database.all.order(:id).each do |record|
      stg += ", " if stg != ""
      stg += record.id.to_s
    end
    stg
  end
end

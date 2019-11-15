# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
public

# Capacitycode.delete_all
#
# code = Capacitycode.create(text: "Super busy, no capacity", number: 4 )
# code.save
#
# code = Capacitycode.create(text: "Busy but some capacity", number: 3 )
# code.save
#
# code = Capacitycode.create(text: "Quite busy but reasonable capacity", number: 2 )
# code.save
#
# code = Capacitycode.create(text: "not busy lots of capacity", number: 1 )
# code.save

# Area.delete_all
#
# area = Area.create(name: "Public law")
# area.save
#
# area = Area.create(name: "Arbitration")
# area.save
#
# area = Area.create(name: "Media law")
# area.save
#
# area = Area.create(name: "IT disputes")
# area.save
#
# area = Area.create(name: "Fraud")
# area.save
#
# area = Area.create(name: "Corporate disputes")
# area.save


groups = [ "Litigation", "Real Estate", "Corporate", "TMC", "EPC", "Finance" ]
Group.delete_all
groups.each do |l|
  Group.create(:name => l)
end

locations = ["London", "Manchester", "Edinburgh", "Sheffield", "Glasgow", "Reading", "Liverpool", "Bristol"]
Location.delete_all
locations.each do |l|
  Location.create(:name => l)
end

lit_group_id = Group.where(:name => "Litigation").first.id
departments = ["L&A", "Employment", "Insurance", "FS lit", "Energy"]
Department.delete_all
departments.each do |dept|
  Department.create(:name => dept, :group_id => lit_group_id)
end

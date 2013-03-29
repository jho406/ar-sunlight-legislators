require 'rake'
require 'rspec/core/rake_task'
require_relative 'db/config'
require_relative 'lib/sunlight_legislators_importer'
require_relative 'app/models/legislator'


desc "create the database"
task "db:create" do
  touch 'db/ar-sunglight-legislators.sqlite3'
end

desc "drop the database"
task "db:drop" do
  rm_f 'db/ar-sunglight-legislators.sqlite3'
end

desc "migrate the database (options: VERSION=x, VERBOSE=false, SCOPE=blog)."
task "db:migrate" do
  ActiveRecord::Migrator.migrations_paths << File.dirname(__FILE__) + 'db/migrate'
  ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
  ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil) do |migration|
    ENV["SCOPE"].blank? || (ENV["SCOPE"] == migration.scope)
  end
end

desc 'Retrieves the current schema version number'
task "db:version" do
  puts "Current version: #{ActiveRecord::Migrator.current_version}"
end

desc "populate the test database with sample data"
task "db:populate" do
  SunlightLegislatorsImporter.import
end


desc "create the database"
task "db:create" do
  touch 'db/ar-sunglight-legislators.sqlite3'
end

namespace :show do

  desc 'Given any state, first print out the senators for that state (sorted by last name), then print out the representatives (also sorted by last name). Include the party affiliation next to the name. '
  task :senators_and_rep_by_state, :state do |t, args|
    sens = Legislator.find_all_by_state_and_title(args[:state], "Sen")
    puts "Senators:"
    sens.each do |sen|
      puts " " + sen.first_name + " " + sen.last_name + " (" + sen.party + ")"
    end

    reps = Legislator.find_all_by_state_and_title(args[:state], "Rep")
    puts "Representatives:"
    reps.each do |rep|
      puts " " + rep.first_name + " " + rep.last_name + " (" + rep.party + ")"
    end

  end

  desc 'Given a gender, print out what number and percentage of the senators are of that gender as well as what number and percentage of the representatives, being sure to include only those congresspeople who are actively in office'
  task :title_by_gender, :sex do |t, args|
    sex = args[:sex][0].upcase
    results = Legislator.count(:conditions => "gender = '#{sex}'", :group=>:title)
    total = results.values.inject(:+)
    puts "#{args[:sex].capitalize} Senators: " + results["Sen"].to_s
    puts "#{args[:sex].capitalize} Representatives: " + results["Rep"].to_s
  end

  desc 'Print out the list of states along with how many active senators and representatives are in each, in descending order '
  task :active_senators_and_state do
    politicians = Legislator.find(:all, 
                  :select => "state, title, count(*) as total_count", 
                  :group => "title, state").group_by{|rep| rep.state}

    politicians.each do |k, v|
      puts k +" "+ v.map{|obj| obj.title + " " + obj.total_count.to_s }.join(",")
    end  
  end

  desc 'For Senators and Representatives, count the total number of each (regardless of whether or not they are actively in office).'
  task :representative_and_count do
    results = Legislator.count(:all, :group=>:title)
    results.each do |title, count|
      p [title, count].join(" ")
    end
  end

  desc "Now use ActiveRecord to delete from your database any congresspeople who are not actively in office, then re-run your count to make sure that those rows were deleted."
  task :delete_and_count do
    Legislator.where(:in_office=>0).destroy_all
    results = Legislator.count(:all, :group=>:title)
    results.each do |title, count|
      p [title, count].join(" ")
    end
  end


end

desc "Run the specs"
RSpec::Core::RakeTask.new(:specs)

task :default  => :specs

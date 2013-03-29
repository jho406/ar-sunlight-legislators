require 'csv'

class SunlightLegislatorsImporter
  def self.import(filename=File.dirname(__FILE__) + "/../db/data/legislators.csv")
    CSV.foreach(File.open(filename), {:headers => true, :header_converters => :symbol}) do |row|
      row = row.to_hash
      row[:phone] = row[:phone].gsub(/\D/,"")
      row[:fax] = row[:phone].gsub(/\D/,"")
      bdy = row[:birthdate].split("/") 
      row[:birthdate] = [bdy[2], bdy[0], bdy[1]].join("-")
      row[:first_name] = row[:firstname]
      row[:last_name] = row[:lastname]
      row[:middle_name] = row[:middlename]
      row.delete(:firstname)
      row.delete(:lastname)
      row.delete(:middlename)

      Legislator.create(row)
    end
  end
end

# begin
#   raise ArgumentError, "you must supply a filename argument" unless ARGV.length == 1
#   SunlightLegislatorsImporter.import(ARGV[0])
# rescue ArgumentError => e
#   $stderr.puts "Usage: ruby sunlight_legislators_importer.rb <filename>"
# rescue NotImplementedError => e
#   $stderr.puts "You shouldn't be running this until you've modified it with your implementation!"
# end

namespace :guides do
  task import_all: :environment do
    Guide.all.each do |guide|
      begin
        guide.import!
      rescue Exception => e
        puts "Could not import guide #{guide.id}. Reason #{e}"
      end
    end
  end
end

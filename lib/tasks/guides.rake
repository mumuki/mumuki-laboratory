namespace :guides do
  task import_all: :environment do
    Guide.all.each do |guide|
      begin
        guide.imports.create!(committer: guide.author).run_import!
        guide.update_collaborators!
      rescue Exception => e
        puts "Could not import guide #{guide.id}"
      end
    end
  end
end

Mumukit::Bridge::Thesaurus.new(Mumukit::Platform.config.thesaurus_url).runners.each do |url|
  puts "Importing Language #{url}"

  begin
    Language.find_or_initialize_by(runner_url: url).import!
  rescue => e
    puts "Ignoring Language #{url} because of import error #{e}"
  end
end

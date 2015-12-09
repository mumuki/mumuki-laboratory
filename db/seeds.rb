if Tenant.on_public?
  puts 'Seeding global'
  Language.create!(name: 'haskell',
                   test_runner_url: 'http://mumuki-hspec-server.herokuapp.com',
                   extension: 'hs',
                   image_url: 'https://www.haskell.org/wikistatic/haskellwiki_logo.png')

  ['pdep-utn/mumuki-funcional-guia-0',
   'pdep-utn/mumuki-funcional-guia-1',
   'pdep-utn/mumuki-funcional-guia-2-orden-superior'].each do |slug|
    puts "Importing #{slug}"
    Guide.create!(url: "http://bibliotheca.mumuki.io/guides/#{slug}").import!
  end

  Tenant.create!(name: 'central').switch!
else
  haskell = Language.for_name 'haskell'
  functional = Chapter.create!(name: 'Programación Funcional',
                                locale: :es,
                                description: 'Programación Funcional',
                                image_url: 'http://mumuki.io/favicon')

  Path.create!(chapter: functional, language: haskell).rebuild!(Guide.all)
end




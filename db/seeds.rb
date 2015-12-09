if Tenant.on_public?
  puts 'Seeding global'
  Language.create!(name: 'haskell',
                   test_runner_url: 'http://mumuki-hspec-server.herokuapp.com',
                   extension: 'hs',
                   image_url: 'https://www.haskell.org/wikistatic/haskellwiki_logo.png')
  Language.create!(name: 'gobstones',
                   test_runner_url: 'http://mumuki-gobstones-server.herokuapp.com',
                   extension: 'gbs',
                   image_url: 'https://avatars3.githubusercontent.com/u/8825549?v=3&s=30')
  Language.create!(name: 'javascript',
                   test_runner_url: 'http://mumuki-mocha-server.herokuapp.com',
                   extension: 'js',
                   image_url: 'http://www.ninjajournal.com/wp-content/uploads/2014/03/javascript_logo_without_title.png')
  Language.create!(name: 'c',
                   test_runner_url: 'http://162.243.111.176:8001',
                   extension: 'c',
                   image_url: 'https://www.haskell.org/wikistatic/haskellwiki_logo.png')
  Language.create!(name: 'c++',
                   test_runner_url: 'http://162.243.111.176:8002',
                   extension: 'cpp',
                   image_url: 'https://www.haskell.org/wikistatic/haskellwiki_logo.png')
  Language.create!(name: 'prolog',
                   test_runner_url: 'http://mumuki-plunit-server.herokuapp.com',
                   extension: 'pl',
                   image_url: '"http://cdn.portableapps.com/SWI-PrologPortable_128.png')
  Language.create!(name: 'ruby',
                   test_runner_url: 'http://162.243.111.176:8000',
                   extension: 'rb',
                   image_url: 'http://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Ruby_logo.svg/1000px-Ruby_logo.svg.png')
  Language.create!(name: 'java',
                   test_runner_url: 'http://162.243.111.176:8003',
                   extension: 'java',
                   image_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Java_logo_and_wordmark.svg/2000px-Java_logo_and_wordmark.svg.png')
  Language.create!(name: 'wollok',
                   test_runner_url: 'http://mumuki-wollok-server.herokuapp.com',
                   extension: 'wlk',
                   image_url: 'https://raw.githubusercontent.com/uqbar-project/wollok/master/org.uqbar.project.wollok.ui/icons/wollok-logo-64.fw.png')



  ['pdep-utn/mumuki-funcional-guia-0',
   'pdep-utn/mumuki-funcional-guia-1',
   'pdep-utn/mumuki-funcional-guia-2-orden-superior'].each do |slug|
    puts "Importing #{slug}"
    Guide.create!(slug: slug).import!
  end

  Tenant.create!(name: 'central', locale: 'es').switch!
else
  Chapter.create!(name: 'Programación Funcional',
                  locale: :es,
                  description: 'Programación Funcional',
                  image_url: 'http://mumuki.io/favicon').rebuild!(Guide.all)
end




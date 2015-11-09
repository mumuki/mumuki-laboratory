haskell = Language.create!(name: 'haskell',
                           test_runner_url: 'http://mumuki-hspec-server.herokuapp.com',
                           extension: 'hs',
                           image_url: 'https://www.haskell.org/wikistatic/haskellwiki_logo.png')

Language.create!(name: 'prolog',
                 test_runner_url: 'http://mumuki-plunit-server.herokuapp.com',
                 extension: 'pl',
                 image_url: 'http://cdn.portableapps.com/SWI-PrologPortable_128.png')

Language.create!(name: 'ruby',
                 test_runner_url: 'http://mumuki-rspec-server.herokuapp.com/',
                 extension: 'rb',
                 image_url: 'https://www.ruby-lang.org/images/header-ruby-logo.png')

Language.create!(name: 'gobstones',
                 test_runner_url: 'http://mumuki-gobstones-server.herokuapp.com/',
                 extension: 'yml',
                 image_url: 'https://www.ruby-lang.org/images/header-ruby-logo.png')


[ "df52800791c4053a",
  "1051a6103501cb75",
  "32f86641962911d1",
  "31322fa7d9003fa3",
  "bafc328faba8a103",
  "eb5f5e4ad07b02d4",
  "c9c71d96902587b6",
  "947312032126df6b",
  "5885fefcda5b9a3c"].each do |id|
  Guide.create!(url: "http://content.mumuki.io/guides/#{id}").import!
end


functional = Category.create!(name: 'Programación Funcional',
                              locale: :es,
                              description: 'Programación Funcional',
                              image_url: 'http://mumuki.io/favicon')

Path.create(category: functional, language: haskell)


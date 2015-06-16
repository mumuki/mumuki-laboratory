Language.create!(name: 'Haskell',
                 test_runner_url: 'http://mumuki-hspec-server.herokuapp.com',
                 extension: 'hs',
                 image_url: 'https://www.haskell.org/wikistatic/haskellwiki_logo.png')

Language.create!(name: 'Prolog',
                 test_runner_url: 'http://mumuki-plunit-server.herokuapp.com',
                 extension: 'pl',
                 image_url: 'http://cdn.portableapps.com/SWI-PrologPortable_128.png')

Language.create!(name: 'Ruby',
                 test_runner_url: 'http://mumuki-rspec-server.herokuapp.com/',
                 extension: 'rb',
                 image_url: 'https://www.ruby-lang.org/images/header-ruby-logo.png')

Language.create!(name: 'ruby-stones',
                test_runner_url: 'http://mumuki-ruby-stones-server.herokuapp.com/',
                extension: 'yml',
                image_url: 'https://www.ruby-lang.org/images/header-ruby-logo.png')

Language.create!(name: 'gobstones',
                test_runner_url: 'http://mumuki-gobstones-server.herokuapp.com/',
                extension: 'yml',
                image_url: 'https://www.ruby-lang.org/images/header-ruby-logo.png')
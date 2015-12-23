def language(attrs)
  name = attrs[:name]
  Language.find_or_create_by(name: name).update!({devicon: name}.merge attrs)
end

language(name: 'haskell',
         test_runner_url: 'http://mumuki-hspec-server.herokuapp.com',
         queriable: true)
language(name: 'gobstones',
         test_runner_url: 'http://mumuki-gobstones-server.herokuapp.com',
         output_content_type: :html)
language(name: 'javascript',
         test_runner_url: 'http://mumuki-mocha-server.herokuapp.com')
language(name: 'c',
         test_runner_url: 'http://162.243.111.176:8001')
language(name: 'c++',
         test_runner_url: 'http://162.243.111.176:8002')
language(name: 'prolog',
         test_runner_url: 'http://mumuki-plunit-server.herokuapp.com')
language(name: 'ruby',
         test_runner_url: 'http://162.243.111.176:8000',
         queriable: true)
language(name: 'java',
         test_runner_url: 'http://162.243.111.176:8003')
language(name: 'wollok',
         test_runner_url: 'http://mumuki-wollok-server.herokuapp.com')

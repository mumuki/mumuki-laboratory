def language(attrs)
  name = attrs[:name]
  Language.find_or_create_by(name: name).update!({devicon: name}.merge attrs)
end

language(name: 'haskell',
         test_runner_url: 'http://mumuki-hspec-server.herokuapp.com',
         queriable: true)
language(name: 'gobstones',
         test_runner_url: 'http://gobstones.runners.mumuki.io',
         output_content_type: :html)
language(name: 'javascript',
         test_runner_url: 'http://javascript.runners.mumuki.io',
         queriable: true)
language(name: 'c',
         test_runner_url: 'http://c.runners.mumuki.io')
language(name: 'c++',
         test_runner_url: 'http://162.243.111.176:8002')
language(name: 'prolog',
         test_runner_url: 'http://mumuki-plunit-server.herokuapp.com',
         queriable: true)
language(name: 'ruby',
         test_runner_url: 'http://ruby.runners.mumuki.io',
         queriable: true)
language(name: 'java',
         test_runner_url: 'http://162.243.111.176:8003')
language(name: 'wollok',
         test_runner_url: 'http://wollok.runners.mumuki.io')
language(name: 'text',
         test_runner_url: 'http://text.runners.mumuki.io')

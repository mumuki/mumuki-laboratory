require 'rest_client'

module RemoteHaskell
  def run_test_file!(file)
    # FIXME refactor plugins input so that we don need to write file and read it again in this case
    # FIXME extract config param
    response = JSON.parse RestClient.post('http://mumuki-hspec-server.herokuapp.com/test', File.new(file.path))
    [response['out'], response['exit'] == 0 ? :passed : :failed]
  end
end
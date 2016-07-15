class RenameTestRunnerUrl < ActiveRecord::Migration
  def change
    rename_column :languages, :test_runner_url, :runner_url
  end
end

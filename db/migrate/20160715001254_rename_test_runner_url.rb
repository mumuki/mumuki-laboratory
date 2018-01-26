class RenameTestRunnerUrl < ActiveRecord::Migration[4.2]
  def change
    rename_column :languages, :test_runner_url, :runner_url
  end
end

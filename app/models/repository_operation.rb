class RepositoryOperation < ActiveRecord::Base
  self.abstract_class = true

  extend WithAsyncAction

  include WithStatus

  belongs_to :guide
  belongs_to :committer, class_name: 'User'

  validates_presence_of :guide, :committer

  delegate :author, to: :guide
  delegate :language, to: :guide

  def with_cloned_repo
    Dir.mktmpdir("mumuki.#{id}.#{self.class.name}") do |dir|
      repo = committer.clone_repo_into guide, dir
      yield dir, repo
    end
  end

end

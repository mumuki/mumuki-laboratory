class PermissionsPersistence::Postgres

  def self.from_config
    new
  end

  def set!(uid, permissions)
    User.find_by(uid: uid).update!(permissions: permissions)
  end

  def get(uid)
    User.find_by(uid: uid)&.permissions || Mumukit::Auth::Permissions.parse({})
  end

  def close
  end

  def clean_env!
  end

end

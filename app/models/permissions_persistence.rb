class PermissionsPersistence

  def self.from_env
    new
  end

  def set!(uid, permissions)
    User.find_by(uid).update!(permissions: permissions)
  end

  def get(uid)
    User.find_by(uid: uid).permissions
  end

  def close
  end

  def clean_env!
  end
end

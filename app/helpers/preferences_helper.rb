module PreferencesHelper
  def uppercase_enabled?(user)
    user.preferences.uppercase? if user
  end
end

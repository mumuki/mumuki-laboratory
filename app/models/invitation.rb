class Invitation < ActiveRecord::Base
  def self.find_by_slug(slug)
    Invitation
      .where(slug: slug)
      .where(Invitation.arel_table[:expiration_date].gt(Date.today))
      .take!
  rescue RangeError
    raise RecordNotFound.new('The invitation does not exist or it has expired')
  end

  def organization
    Organization.find_by! name: Mumukit::Auth::Slug.parse(course).organization
  end
end

class Invitation < ApplicationRecord
  def self.find_by_code(code)
    Invitation
      .where(code: code)
      .where(Invitation.arel_table[:expiration_date].gt(Time.now))
      .take!
  rescue RangeError
    raise RecordNotFound.new('The invitation does not exist or it has expired')
  end

  def self.import_from_resource_h!(json)
    Invitation.create! json
  end

  def organization
    Organization.find_by! name: course.to_mumukit_slug.organization
  end

  def navigable_name
    I18n.t(:invitation_for, course: course_name)
  end

  def navigation_end?
    true
  end

  def to_param
    code
  end

  private

  def course_name
    course.to_mumukit_slug.course
  end
end

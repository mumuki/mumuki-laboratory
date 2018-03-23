require 'spec_helper'

describe 'CourseChanged' do
  let(:course_json) do
    {slug: 'test/bar',
     shifts: %w(morning),
     code: 'k2003',
     days: %w(monday wednesday),
     period: '2016',
     description: 'test course'}
  end

  let!(:course) { Course.import_from_json! course_json }

  it { expect(course.organization.courses).to include course }
  it { expect(course.organization.name).to eq 'test' }

  it { expect(course.slug).to eq 'test/bar' }
  it { expect(course.code).to eq 'k2003' }
  it { expect(course.days).to eq %w(monday wednesday) }
  it { expect(course.period).to eq '2016' }
end

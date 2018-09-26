require 'spec_helper'

describe Api::CoursesController, type: :controller, organization_workspace: :base do
  before { set_api_client! api_client }
  let(:api_client) { create :api_client }
  let(:course_json) do
    {slug: 'test/bar',
     shifts: %w(morning),
     code: 'k2003',
     days: %w(monday wednesday),
     period: '2016',
     description: 'test course'}
  end

  let!(:organization) { create :organization, name: 'test' }

  context 'post' do
    before { post :create, params: { course: course_json }}

    it { expect(response.status).to eq 200 }
    it { expect(Course.count).to eq 1 }
    it { expect(Course.first.slug).to eq 'test/bar' }
    it { expect(Course.first.organization).to eq(organization) }
    it { expect(Course.first.shifts).to eq(%w(morning)) }
    it { expect(Course.first.days).to eq(%w(monday wednesday)) }
  end

end

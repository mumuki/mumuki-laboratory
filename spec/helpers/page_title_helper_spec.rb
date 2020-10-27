require 'spec_helper'

describe PageTitleHelper, organization_workspace: :test do
  helper PageTitleHelper

  describe 'page_title' do
    let(:exercise) { lesson.exercises.first }
    let(:lesson) {
      create(:lesson, name: 'A Guide', exercises: [
          create(:exercise, name: 'An Exercise')]) }
    let!(:chapter) { create(:chapter, name: 'C1', lessons: [lesson]) }

    before { reindex_current_organization! }

    it { expect(page_title nil).to eq 'test' }
    it { expect(page_title Problem.new).to eq 'test' }
    it { expect(page_title exercise).to eq 'C1: A Guide - An Exercise - test' }
  end
end

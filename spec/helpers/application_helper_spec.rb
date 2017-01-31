require 'spec_helper'

describe ApplicationHelper do
  helper ApplicationHelper
  helper FontAwesome::Rails::IconHelper

  before { I18n.locale = :en }

  describe 'page_title' do
    context 'in path' do
      let(:exercise) { lesson.exercises.first }
      let(:lesson) {
        create(:lesson, name: 'A Guide', exercises: [
            create(:exercise, name: 'An Exercise')]) }
      let!(:chapter) { create(:chapter, name: 'C1', lessons: [lesson]) }

      before { reindex_current_organization! }

      it { expect(page_title nil).to eq 'Mumuki - Improve your programming skills' }
      it { expect(page_title Problem.new).to eq 'Mumuki - Improve your programming skills' }
      it { expect(page_title exercise).to eq 'C1: A Guide - An Exercise - Mumuki' }
    end
  end
end

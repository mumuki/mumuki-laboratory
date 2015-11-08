require 'spec_helper'

describe Guide do
  let(:author) { create(:user, name: 'rigoberto88') }
  let!(:extra_user) { create(:user, name: 'ignatiusReilly') }
  let(:guide) { create(:guide, author: author) }

  describe '#next_for' do
    let(:path) { create(:path) }

    context 'when guide is not in path' do
      it { expect(guide.next_for(extra_user)).to be nil }
    end
    context 'when guide is in path' do
      let(:guide_in_path) { create(:guide) }

      context 'when it is single' do
        before { path.rebuild!([create(:guide), guide_in_path]) }

        it { expect(guide_in_path.next_for(extra_user)).to be nil }
        it { expect(guide_in_path.path).to eq path }
      end

      context 'when there is a next guide' do
        let!(:other_guide) { create(:guide) }
        before { path.rebuild!([create(:guide), guide_in_path, other_guide]) }

        it { expect(guide_in_path.next_for(extra_user)).to eq other_guide }
      end
      context 'when there are many next guides at same level' do
        let!(:other_guide_1) { create(:guide) }
        let!(:other_guide_2) { create(:guide) }

        before { path.rebuild!([create(:guide), guide_in_path, other_guide_1, other_guide_2]) }

        it { expect(guide_in_path.next_for(extra_user)).to eq other_guide_1 }
      end
    end
  end

  describe '#contextualized_name' do
    let(:path) { create(:path) }
    context 'when guide is not in path' do
      it { expect(guide.contextualized_name).to be guide.name }
    end
    context 'when guide is in path' do
      let!(:guide_in_path) { create(:guide) }
      before { path.rebuild! [create(:guide), guide_in_path] }

      it { expect(guide_in_path.contextualized_name).to eq "2. #{guide_in_path.name}" }
    end
  end

  describe '#slugged_name' do
    let(:path) { create(:path) }
    context 'when guide is not in path' do
      it { expect(guide.slugged_name).to be guide.name }
    end
    context 'when guide is in path' do
      let(:guide_in_path) { create(:guide) }

      before do
        path.rebuild!([create(:guide), guide_in_path])
      end

      it { expect(guide_in_path.slugged_name).to eq "#{path.name}: #{guide_in_path.name}" }
    end
  end

  describe '#slug' do
    context 'when guide is not in path' do
      let(:guide_not_in_path) { create(:guide, name: 'Una Guia', id: 80) }
      it { expect(guide_not_in_path.slug).to eq '80-una-guia' }
    end
    context 'when guide is in path' do
      let(:category) { create(:category, name: 'Fundamentos de Programacion') }
      let(:path) { create(:path, category: category) }
      let(:guide_in_path) { create(:guide, name: 'Una Guia', id: 180) }

      before do
        path.rebuild!([create(:guide), create(:guide), guide_in_path])
      end

      it { expect(guide_in_path.path).to eq path }
      it { expect(guide_in_path.slug).to eq '180-fundamentos-de-programacion-una-guia' }
    end
  end

  describe '#new?' do
    context 'when just created' do
      it { expect(guide.new?).to be true }
    end
    context 'when created a month ago' do
      before { guide.update!(created_at: 1.month.ago) }

      it { expect(guide.new?).to be false }
    end
  end


  describe '#submission_contents_for' do
    before do
      guide.exercises = [create(:exercise, language: guide.language), create(:exercise, language: guide.language)]
      guide.save!
    end

    context 'when no submission' do
      it { expect(guide.solutions_for(extra_user)).to eq [] }
    end
    context 'when there are submissions' do
      before do
        guide.exercises.first.submit_solution!(extra_user, content: 'foo1')
        guide.exercises.first.submit_solution!(extra_user, content: 'foo2')
        guide.exercises.second.submit_solution!(extra_user, content: 'bar')
      end
      it { expect(guide.solutions_for(extra_user)).to eq %w(foo2 bar) }
    end
  end
end

namespace :slugs do
  def update_slugs(model_class)
    model_class.all.each do |it|
      it.slug = nil
      it.save!
    end
  end

  task update_for_exercises: :environment do
    update_slugs(Exercise)
  end

  task update_for_guides: :environment do
    update_slugs(Guide)
  end
end

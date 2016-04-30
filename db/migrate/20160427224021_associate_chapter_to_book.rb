class AssociateChapterToBook < ActiveRecord::Migration
  def change
    Chapter.all.each do |it|
      it.update!(book: Organization.current.book)
    end
  end
end

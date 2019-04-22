module AuthorsHelper

  def attribution_caption(guide)
    if guide.collaborators.present?
      t(:authoring_note_with_collaborators, authors: guide.authors, collaborators: "https://raw.githubusercontent.com/#{guide.slug}/master/COLLABORATORS.txt")
    else
      t(:authoring_note, authors: guide.authors)
    end
  end
end

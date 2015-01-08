module Flags
  def flag(locale)
    name = case locale.to_s
      when 'en' then 'us'
      when 'es' then 'es'
    end
    image_tag("#{name}.png")
  end
end

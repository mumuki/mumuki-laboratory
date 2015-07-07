module Flags #FIXME remove
  def flag(locale, options={})
    name = case locale.to_s
      when 'en' then 'us'
      when 'es' then 'es'
    end
    image_tag("#{name}.png", options)
  end
end

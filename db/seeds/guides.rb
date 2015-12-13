['pdep-utn/mumuki-funcional-guia-0',
 'pdep-utn/mumuki-funcional-guia-1',
 'pdep-utn/mumuki-funcional-guia-2-orden-superior'].each do |slug|
  puts "Importing #{slug}"
  Guide.create!(slug: slug).import!
end

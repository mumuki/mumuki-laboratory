class AddLogoUrlToOrgas < ActiveRecord::Migration
  def change
    urls = {'central' => 'http://mumuki.io/logo-alt-large.png',
     'pdep-utn' => 'https://www.frba.utn.edu.ar/wp-content/themes/frba-utn/images/logo.png',
     'pdep-utn-frd' => 'http://www.frd.utn.edu.ar/sites/all/themes/icompany/logo.png',
     'alcal' => 'https://avatars1.githubusercontent.com/u/11892423?v=3&s=200',
     'inpr-unq' => 'http://www.unq.edu.ar/images/logo_unqui.png',
     'inpr-sarmiento' => 'http://www.unq.edu.ar/images/logo_unqui.png',
     'pdp-unsam' => 'http://www.unsam.edu.ar/img/logo-unsam.png',
     'algo2-undav' => 'http://www.undav.edu.ar/general/recursos/adjuntos/11381.png',
     'orga-unq' => 'http://www.unq.edu.ar/images/logo_unqui.png',
     'algo1-unsam' => 'http://www.unsam.edu.ar/img/logo-unsam.png',
     'obj3-unq' => 'http://www.unq.edu.ar/images/logo_unqui.png',
     'demo' => 'http://mumuki.io/logo-alt-large.png',
     'iasc' => 'http://mumuki.io/logo-alt-large.png',
     'digitalhouse' => 'http://mumuki.io/logo-alt-large.png'}

    Organization.all.each do |org|
      org.logo_url = urls[org.name]
      org.save!
    end
  end
end

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.box_check_update = false
  # (`vagrant box outdated` to update)

  config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.provision "shell",
    name: "Install environment",
    inline: %{
      cd /vagrant
      curl -#LO https://rvm.io/mpapis.asc
      gpg --import mpapis.asc
      curl -sSL https://get.rvm.io | bash -s stable
      . /home/vagrant/.rvm/scripts/rvm
      rvm install ruby-2.0.0-p481
      gem install bundler

      sudo apt-get install -y postgresql libpq-dev
      echo "create role mumuki with createdb login password 'mumuki';" > /tmp/create_role.sql
      sudo -u postgres psql -a -f /tmp/create_role.sql

      echo 'deb http://www.rabbitmq.com/debian/ testing main' |
              sudo tee /etc/apt/sources.list.d/rabbitmq.list
      wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc |
              sudo apt-key add -
      sudo apt-get update
      sudo apt-get install -y git rabbitmq-server

      bundle install
      rake db:create db:migrate db:seed
    },
    privileged: false
end

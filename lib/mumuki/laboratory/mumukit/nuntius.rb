require 'mumukit/nuntius'

Mumukit::Nuntius.configure do |c|

end

module Mumuki
  module Laboratory
    Nuntius = Mumukit::Nuntius::Component.new('laboratory')
  end
end

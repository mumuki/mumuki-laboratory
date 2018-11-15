require 'securerandom'

module Mumuki::Domain
  module Submission
  end
end

require_relative './submission/base'
require_relative './submission/persistent_submission'
require_relative './submission/console_submission'
require_relative './submission/try'
require_relative './submission/solution'
require_relative './submission/question'
require_relative './submission/query'
require_relative './submission/confirmation'




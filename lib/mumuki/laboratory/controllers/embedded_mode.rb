# This mixin provides support for implementing the
# embedded mode - as opposed to the standalone mode -in which
# the mumuki pages
#
#  * are displayed used a simplified layout, called `embedded.html.erb`
#  * are served using `X-Frame-Options` that allow them to be used within
#    an iframe
#
# Not all organizations can be emedded - only those that have the `embeddable?`
# setting set.
#
# This mixin provides two sets of methods:
#
# * `embedded_mode?` / `standalone_mode?`, which are helpers aimed to be used by views
#    and change very specific rendering details in one or the other mode
# *  `enable_embedded_rendering`, which is designed to be called from main-views controller-methods that
#     actually support embedded mode.
module Mumuki::Laboratory::Controllers::EmbeddedMode
  extend ActiveSupport::Concern

  included do
    helper_method :embedded_mode?,
                  :standalone_mode?
  end

  def embedded_mode?
    @embedded_mode ||= params[:embed] == 'true' && Organization.current.embeddable?
  end

  def standalone_mode?
    !embedded_mode?
  end

  def enable_embedded_rendering
    return unless embedded_mode?
    allow_parent_iframe!
    render layout: 'embedded'
  end

  private

  def allow_parent_iframe!
    response.delete_header 'X-Frame-Options'
  end
end

class CertificatesController < ApplicationController
  before_action :authorize_if_private!, only: [:show]
  before_action :set_certificate!
  before_action :validate_current_user!, only: [:download]

  include CertificateHelper

  def verify
  end

  def show
  end

  def download
    send_data pdf_for(@certificate), filename: @certificate.filename
  end

  private

  def set_certificate!
    @certificate = Certificate.find_by! code: params[:code]
  end

  def validate_current_user!
    raise Mumuki::Domain::NotFoundError.new unless certificates_current_user? @certificate
  end
end

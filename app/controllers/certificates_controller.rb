class CertificatesController < ApplicationController
  before_action :authorize_if_private!, only: [:show]
  before_action :set_certificate!

  def verify
  end

  def show
  end

  def download
    pdf_html = render_to_string(partial: 'certificates/download', locals: { certificate: @certificate })
    pdf = WickedPdf.new.pdf_from_string pdf_html,
                                        orientation: 'Landscape',
                                        page_size: 'A5',
                                        margin: { top: 0.5, left: 1, bottom: 0.5, right: 1 }

    send_data pdf, filename: "#{@certificate.title.parameterize.underscore}.pdf"
  end

  private

  def set_certificate!
    @certificate = Certificate.find_by! code: params[:code]
  end

end

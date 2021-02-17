require 'rqrcode'

module WithCertificateRender

  extend ActiveSupport::Concern

  included do
    helper_method :qr_for
  end

  def qr_for(certificate)
    qr = RQRCode::QRCode.new(verify_certificate_url certificate.code).as_svg(color: '0B465D')
    "data:image/svg+xml,#{URI.encode(qr)}"
  end

  def pdf_for(certificate)
    pdf_html = render_to_string(partial: 'certificates/download', locals: { certificate: certificate })
    WickedPdf.new.pdf_from_string pdf_html,
                                  orientation: 'Landscape',
                                  page_size: 'A5',
                                  margin: { top: 0.5, left: 1, bottom: 0.5, right: 1 }

  end
end

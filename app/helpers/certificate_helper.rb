require 'rqrcode'

module CertificateHelper
  def linkedin_url_to_post(certificate)
    URI::HTTPS.build host: 'www.linkedin.com',
                     path: '/profile/add',
                     query: Rack::Utils.build_query(startTask: 'CERTIFICATION_NAME',
                                                    name: certificate.title,
                                                    organizationId: 3648837,
                                                    issueYear: certificate.created_at.year,
                                                    issueMonth: certificate.created_at.month,
                                                    certUrl: verify_certificate_url(certificate.code),
                                                    certId: certificate.code)
  end

  def certificates_current_user?(certificate)
    certificate.user == current_user
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

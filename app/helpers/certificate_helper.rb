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
end

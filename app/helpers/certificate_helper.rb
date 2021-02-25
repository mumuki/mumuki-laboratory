module CertificateHelper
  def linkedin_post_url(certificate)
    URI::HTTPS.build host: 'www.linkedin.com',
                     path: '/profile/add',
                     query: Rack::Utils.build_query(startTask: 'CERTIFICATION_NAME',
                                                    name: certificate.title,
                                                    organizationId: ENV['MUMUKI_LINKEDIN_ORGANIZATION_ID'],
                                                    issueYear: certificate.created_at.year,
                                                    issueMonth: certificate.created_at.month,
                                                    certUrl: verify_certificate_url(certificate.code),
                                                    certId: certificate.code)
  end
end

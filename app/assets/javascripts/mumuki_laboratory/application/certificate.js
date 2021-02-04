mumuki.load(() => {
  scaleCertificate();
  mumuki.resize(scaleCertificate);
})

function scaleCertificate() {
  const $certPreview = $('.certificate-preview');
  const $muCertificate = $('.mu-certificate-box');
  $muCertificate.css('transform', 'scale(1)');

  const scaleWidth = $muCertificate.width() / $certPreview.width();
  $muCertificate.css({
    'transform': `scale(${1 / scaleWidth})`,
    'transform-origin': `0 0`,
  });
  $certPreview.height($muCertificate.height());
}

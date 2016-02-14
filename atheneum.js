var page = require('webpage').create();
page.open('http://localmumuki.io:3000/pdfs', function() {

  page.paperSize = {
    format: 'A4',
    margin: '1.3cm',
    header: {
      height: "1cm",
      contents: phantom.callback(function(pageNum, numPages) {
        return "Mumuki";
      })
    },
    footer: {
      height: "1cm",
      contents: phantom.callback(function(pageNum, numPages) {
        return "<span style='float:right'>" + pageNum + "</span>";
      })
    }
  }
  page.render('mumuki-book.pdf');
  phantom.exit();
});

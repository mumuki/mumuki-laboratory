// This module defines three client-side-only special sections, and allows them to be replaced
// by adding the `mu-elipsis` class, or by calling `mumuki.elipsis()`:
//
// * <elipsis-for-student@ ...code... @elipsis-for-student>                     : replaces code with an elipsis
// * <hidden-for-student@ ...code... @hidden-for-student>                       : completely hides code
// * <description-for-student[...text...]@ ...code... @description-for-student> : replaces code a message sourrounded by elipsis
//
//
// This module assumes the strings are already markdown-like escaped code strings, not plain code
mumuki.elipsis = (() => {

  function elipsis(code) {
    return code
      .replace(/&lt;elipsis-for-student@[\s\S]*?@elipsis-for-student&gt;/g, ' ... ')
      .replace(/&lt;hidden-for-student@[\s\S]*?@hidden-for-student&gt;/g, '')
      .replace(/&lt;description-for-student\[([^\]]*)\]@[\s\S]*?@description-for-student&gt;/g, ' ... $1 ... ');
  }

  elipsis.replaceHtml = () => {
    let $elipsis = $('.mu-elipsis');
    $elipsis.each((it, e) =>  {
      let $e = $(e);
      $e.html(mumuki.elipsis($e.html()));
    });
  };

  mumuki.load(() => {
    mumuki.elipsis.replaceHtml();
  });

  return elipsis;
})();

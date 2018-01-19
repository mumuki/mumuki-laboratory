mumuki.resize(function () {
  var margin = 15;
  var fullMargin = margin * 2;

  var gbsBoard = $('[class^="mu-kids-gbs-board"]');
  gbsBoard.each(function (i) {
    var $gsBoard = $(gbsBoard[i]);
    var $table = $gsBoard.find('gs-board > table');
    $table.css('transform', 'scale(1)');
    var scaleX = ($gsBoard.width() - fullMargin) / $table.width();
    var scaleY = ($gsBoard.height() - fullMargin) / $table.height();
    $table.css('transform', 'scale(' + Math.min(scaleX, scaleY) + ')');
  });

  var $muKidsBlocks = $('.mu-kids-blocks');
  var $blockArea = $muKidsBlocks.find('#blocklyDiv');
  var $blockSvg = $muKidsBlocks.find('.blocklySvg');

  $blockArea.width($muKidsBlocks.width());
  $blockArea.height($muKidsBlocks.height());

  $blockSvg.width($muKidsBlocks.width());
  $blockSvg.height($muKidsBlocks.height());

});

mumuki.load(function () {

  mumuki.resize(function () {
    var margin = 15;
    var fullMargin = margin * 2;

    var gbsBoard = $('[class^="mu-kids-gbs-board"]');

    var dimension = gbsBoard.height() - margin * 2;
    gbsBoard.width(dimension);

    var $muKidsExercise = $('.mu-kids-exercise');
    var $muKidsExerciseDescription = $('.mu-kids-exercise-description');

    $muKidsExerciseDescription.width($muKidsExercise.width() - gbsBoard.width() - margin);

    gbsBoard.each(function (i) {
      gsBoardScale($(gbsBoard[i]));
    });

    var $muKidsBlocks = $('.mu-kids-blocks');
    var $blockArea = $muKidsBlocks.find('#blocklyDiv');
    var $blockSvg = $muKidsBlocks.find('.blocklySvg');

    $blockArea.width($muKidsBlocks.width());
    $blockArea.height($muKidsBlocks.height());

    $blockSvg.width($muKidsBlocks.width());
    $blockSvg.height($muKidsBlocks.height());

    function gsBoardScale($element) {
      var $table = $element.find('gs-board > table');
      $table.css('transform', 'scale(1)');
      var scaleX = ($element.width() - fullMargin * 2) / $table.width();
      var scaleY = ($element.height() - fullMargin * 2) / $table.height();
      $table.css('transform', 'scale(' + Math.min(scaleX, scaleY) + ')');
    }

  });

  var currentParagraphIndex = 0;
  var $speechParagraphs = $('.mu-kids-character-speech-bubble > p');
  var $prevSpeech = $('.mu-kids-character-speech-bubble > .mu-kids-prev-speech').hide();
  var $nextSpeech = $('.mu-kids-character-speech-bubble > .mu-kids-next-speech');

  $nextSpeech.click(function () {
    hideCurrentParagraph();
    showNextParagraph();
  });
  $prevSpeech.click(function () {
    hideCurrentParagraph();
    showPrevParagraph();
  });

  function hideCurrentParagraph() {
    $($speechParagraphs[currentParagraphIndex]).hide();
  }

  function showPrevParagraph() {
    $nextSpeech.show();
    $($speechParagraphs[--currentParagraphIndex]).show();
    if (currentParagraphIndex === 0) $prevSpeech.hide();
  }

  function showNextParagraph() {
    $prevSpeech.show();
    $($speechParagraphs[++currentParagraphIndex]).show();
    if ($speechParagraphs.length - 1 === currentParagraphIndex) $nextSpeech.hide();
  }

  mumuki.showKidsResult = function (data) {
    if (data.guide_finished_by_solution) return;

    $(".submission-results").html(data.html);

    var results_kids_modal = $('#kids-results');
    if (results_kids_modal) results_kids_modal.modal();
  }
});

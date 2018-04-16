mumuki.load(function () {

  mumuki.resize(function () {
    var margin = 15;
    var fullMargin = margin * 2;

    var gbsBoard = $('.mu-kids-state');

    var dimension = gbsBoard.height() * 1.25 - fullMargin;
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

  var $speechParagraphs;
  var currentParagraphIndex = 0;
  var $prevSpeech = $('.mu-kids-character-speech-bubble > .mu-kids-prev-speech').hide();
  var $nextSpeech = $('.mu-kids-character-speech-bubble > .mu-kids-next-speech');

  updateSpeechParagraphs();

  function updateSpeechParagraphs() {
    $speechParagraphs = $('.mu-kids-character-speech-bubble > p');
  }

  var $speechTabs = $('.mu-kids-character-speech-bubble-tabs > li:not(.separator)');
  var $bubble = $('.mu-kids-character-speech-bubble');
  var $texts = $bubble.children('.description, .hint');

  $speechTabs.each(function (i) {
    var $tab = $($speechTabs[i]);
    $tab.click(function () {
      $speechTabs.removeClass('active');
      $tab.addClass('active');
      $texts.hide();
      $bubble.children('.' + $tab.data('target')).show();
      updateSpeechParagraphs();
    })
  });

  if ($speechParagraphs.length <= 1) $nextSpeech.hide();

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

  mumuki.getKidsResultsModal = function () {
    return $('#kids-results');
  };

  mumuki.getKidsCharaterImage = function () {
    return $('.mu-kids-character > img');
  };

  mumuki.showKidsResult = function (data) {
    mumuki.updateProgressBarAndShowModal(data);
    if (data.guide_finished_by_solution) return;
    $bubble = $('.mu-kids-character-speech-bubble');
    mumuki.kids.resultAction[data.status]($bubble, data);
  };

  mumuki.kids = {};
  mumuki.kids.resultAction = {};
  mumuki.kids.resultAction._onSuccessLike = function ($bubble, data) {
    $('.submission-results').html(data.html);
    var results_kids_modal = mumuki.getKidsResultsModal();
    if (results_kids_modal) {
      results_kids_modal.modal();
      results_kids_modal.find('.modal-header').first().html(data.title_html);
      results_kids_modal.find('.modal-footer').first().html(data.button_html);
    }
  };
  mumuki.kids.resultAction._onErrorLike = function ($bubble, data) {
    $bubble.find('.description').hide();
    $bubble.find('.hint').hide();
    $bubble.find('.failed').show().html(data.title_html);
    $bubble.addClass(data.status);
    $('.mu-kids-overlay').show();
    mumuki.getKidsCharaterImage().attr('src', '/amarillo_fracaso.svg');
  };

  mumuki.kids.resultAction._restart = function ($bubble) {
    $bubble.find('.description').show();
    $bubble.find('.hint').show();
    $bubble.find('.failed').hide();
    $('.mu-kids-overlay').hide();
    Object.keys(mumuki.kids.resultAction).forEach($bubble.removeClass.bind($bubble));
    mumuki.getKidsCharaterImage().attr('src', '/anim_amarillo.svg');
  };

  mumuki.kids.resultAction.passed = mumuki.kids.resultAction._onSuccessLike;
  mumuki.kids.resultAction.passed_with_warnings = mumuki.kids.resultAction._onSuccessLike;
  mumuki.kids.resultAction.failed = mumuki.kids.resultAction._onErrorLike;
  mumuki.kids.resultAction.errored = mumuki.kids.resultAction._onErrorLike;
  mumuki.kids.resultAction.aborted = mumuki.kids.resultAction._onErrorLike;
  mumuki.kids.resultAction.pending = mumuki.kids.resultAction._onErrorLike

});

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
  var $bubble = $('.mu-kids-character-speech-bubble').children('.mu-kids-character-speech-bubble-normal');
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

  mumuki.kids = {

    getResultsModal: function () {
      return $('#kids-results');
    },

    getCharaterImage: function () {
      return $('.mu-kids-character > img');
    },

    getCharacterBubble: function () {
      return $('.mu-kids-character-speech-bubble');
    },

    getSubmissionResult: function () {
      return $('.submission-results');
    },

    getOverlay: function () {
      return $('.mu-kids-overlay');
    },

    showResult: function (data) {  // This function is called by the custom runner
      mumuki.updateProgressBarAndShowModal(data);
      if (data.guide_finished_by_solution) return;
      mumuki.kids.resultAction[data.status](data);
    },

    restart: function () {  // This function is called by the custom runner
      mumuki.kids._hideFailedMessage();
      var $bubble = mumuki.kids.getCharacterBubble();
      Object.keys(mumuki.kids.resultAction).forEach($bubble.removeClass.bind($bubble));
      mumuki.kids.getCharaterImage().attr('src', '/anim_amarillo.svg');
    },

    _hideFailedMessage: function () {
      var $bubble = mumuki.kids.getCharacterBubble();
      $bubble.find('.mu-kids-character-speech-bubble-tabs').show();
      $bubble.find('.mu-kids-character-speech-bubble-normal').show();
      $bubble.find('.mu-kids-character-speech-bubble-failed').hide();
      Object.keys(mumuki.kids.resultAction).forEach($bubble.removeClass.bind($bubble));
      mumuki.kids.getOverlay().hide();
    },

    _showFailedMessage: function (data) {
      var $bubble = mumuki.kids.getCharacterBubble();
      $bubble.find('.mu-kids-character-speech-bubble-tabs').hide();
      $bubble.find('.mu-kids-character-speech-bubble-normal').hide();
      $bubble.find('.mu-kids-character-speech-bubble-failed').show().html(data.title_html);
      $bubble.addClass(data.status);
      mumuki.kids.getOverlay().show();
    },

    _showOnPopup: function (data) {
      this.getSubmissionResult().html(data.html);
      mumuki.kids.getCharaterImage().attr('src', '/amarillo_fracaso.svg');
      mumuki.kids._showFailedMessage(data);
      setTimeout(function () {
        var results_kids_modal = mumuki.kids.getResultsModal();
        if (results_kids_modal) {
          results_kids_modal.modal();
          results_kids_modal.find('.modal-header').first().html(data.title_html);
          results_kids_modal.find('.modal-footer').first().html(data.button_html);
        }
      }, 1000 * 3);
    },

    _showOnCharacterBubble: function (data) {
      mumuki.kids.getCharaterImage().attr('src', '/amarillo_fracaso.svg');
      mumuki.kids._showFailedMessage(data);
    },

    resultAction: {}

  };

  mumuki.kids.resultAction.passed = mumuki.kids._showOnPopup;
  mumuki.kids.resultAction.aborted = mumuki.kids._showOnPopup;
  mumuki.kids.resultAction.passed_with_warnings = mumuki.kids._showOnPopup;

  mumuki.kids.resultAction.failed = mumuki.kids._showOnCharacterBubble;
  mumuki.kids.resultAction.errored = mumuki.kids._showOnCharacterBubble;
  mumuki.kids.resultAction.pending = mumuki.kids._showOnCharacterBubble;

  mumuki.kids.resultAction.passed = mumuki.kids._showOnCharacterBubble;
  mumuki.kids.resultAction.aborted = mumuki.kids._showOnCharacterBubble;
  mumuki.kids.resultAction.passed_with_warnings = mumuki.kids._showOnCharacterBubble;

});

mumuki.MultipleScenarios = (() => {

  const setControlVisibility = function ($control, visible) {
    visible ? $control.show() : $control.hide();
  };

  const addClickListener = function($element, listener) {
    $element.on('click', listener);
  };

  const getControlElement = function(controlSelector) {
    return $(`.mu-scenario-control.${controlSelector} i`);
  };

  const statusIconMap = new Map([
    ['pending', 'fa-circle'],
    ['passed', 'fa-check-circle'],
    ['failed', 'fa-times-circle']
  ]);

  const highlightAnimationClass = 'jump';

  const statusesClasses = Array.from(statusIconMap.keys());
  const iconsClasses = Array.from(statusIconMap.values());
  const indicatorsClasses = iconsClasses.concat(statusesClasses);

  const getClassesFor = (status) => [status, statusIconMap.get(status)];

  const wrapScenario = ($scenario) => $scenario.wrap("<div class='mu-scenario'></div>").parent();

  const setIndicatorStatus = function (indicator, status) {
    const indicatorClassList = indicator.classList;
    const statusClasses = getClassesFor(status);
    indicatorClassList.remove(...indicatorsClasses);
    indicatorClassList.add(...statusClasses);
  };

  const unhighlightIndicator = function ($indicator) {
    $indicator.classList.remove(highlightAnimationClass);
  };

  const highlightIndicator = function ($indicator) {
    $indicator.classList.add(highlightAnimationClass);
  };

  const triggerResize = function () {
    let event = document.createEvent('HTMLEvents');
    event.initEvent('resize', true, false);
    document.dispatchEvent(event);
  };

  class MultipleScenarios {
    constructor(selectors) {
      this.indicators = $('.mu-multiple-scenarios .indicators');
      this.initialize(selectors);
    }

    initialize (selectors) {
      this.createScenarios(selectors);
      this.createControls();
      this.createIndicators();
      this.setActiveIndex(0);
      $('.mu-scenario-control').removeClass('d-none');
    }

    validScenarioIndex (index) {
      return index >= 0 && index < this.scenariosCount;
    }

    createControlListener ($control, changeStep) {
      addClickListener($control, () => {
        const newScenarioIndex = this.currentScenarioIndex + changeStep;
        if (this.validScenarioIndex(newScenarioIndex)) {
          this.setActiveIndex(newScenarioIndex);
        }
      });
    }

    createControls () {
      this.previousControl = getControlElement('previous');
      this.nextControl = getControlElement('next');
      this.createControlListener(this.previousControl, -1);
      this.createControlListener(this.nextControl, 1);
    }

    createScenarios (selectors) {
      let $scenarios = selectors.map(selector => $(`.mu-multiple-scenarios ${selector}`));
      this.scenarios = $scenarios.map($scenario => wrapScenario($scenario));
      this.scenariosCount = this.scenarios[0].length;
    }

    createIndicators () {
      for (let index = 0; index < this.scenariosCount; index++) {
        let $indicator = $('<li class="fa"></li>');
        this.indicators.append($indicator);
        let indicatorIndex = index;
        addClickListener($indicator, () => {
          this.setActiveIndex(indicatorIndex);
        });
      }
      this.indicatorItems = this.indicators.children('li');
      this.resetIndicators();
    }

    setActiveIndex (index) {
      this.currentScenarioIndex = index;
      this.setActiveScenario(index);
      unhighlightIndicator(this.indicatorItems[index]);
      this.updateControls(index);
      triggerResize();
    }

    updateControls (index) {
      setControlVisibility(this.previousControl, index !== 0);
      setControlVisibility(this.nextControl, index !== this.scenariosCount - 1);
    }

    setActiveScenario (index) {
      [...this.scenarios, this.indicatorItems].forEach(($scenario) => {
        $scenario.removeClass('active');
        $scenario[index].classList.add('active');
      });
    }

    updateIndicators (testResultsStatuses) {
      testResultsStatuses.forEach((status, index) => {
        const $indicator = this.indicatorItems[index];
        setIndicatorStatus($indicator, status);
      });
      this.highlightFailedScenario(testResultsStatuses);
    }

    highlightFailedScenario (testResultsStatuses) {
      const currentStatus = testResultsStatuses[this.currentScenarioIndex];
      const isCurrentFailed = currentStatus === 'failed';
      const $failedIndicator = this.indicatorItems.filter('.failed')[0];
      if($failedIndicator && !isCurrentFailed) highlightIndicator($failedIndicator);
    }

    resetIndicators () {
      this.indicatorItems.each((_, $indicator) => {
        setIndicatorStatus($indicator, 'pending');
        unhighlightIndicator($indicator);
      });
    }
  }

  return MultipleScenarios;
})();

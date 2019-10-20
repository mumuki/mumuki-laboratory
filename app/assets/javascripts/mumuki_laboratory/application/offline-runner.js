(() => {
  const BasicLocalTestRunner = new class {
    // This basic runner does not perform any test evaluation, but sets a default
    // passed state, with no test results. This could be improved in the future.
    runTests(solution, exercise, result) {
      result.status = "passed";
      result.test_results = []
    }
  }

  const MulangLocalExpectationsRunner = new class {
    _getMulangCode(solution, exercise, result) {
      return result.mulangAst ? mulang.astCode(result.mulangAst) : mulang.nativeCode(exercise.language, solution);
    }

    _expectationsFailed(analysisResult) {
      return analysisResult.expectationResults.some((it) => !it.result);
    }

    runExpectations(solution, exercise, result) {
      try {
        const analysisResult = this
                                ._getMulangCode(solution, exercise, result)
                                .analyse({ expectations: exercise.expectations });
        if (this._expectationsFailed(analysisResult) && result.status == 'passed') {
          result.status = 'passed_with_warnings';
        }
        result.expectations_html = '';
      } catch (e) {
        console.warn(`[Mumuki::Laboratory::OfflineRunner] Mulang crashed with ${JSON.stringify(e)}`);
      }
    }
  }

  function initialLocalResult() {
    return {
      // FIXME use a roadmap
      guide_finished_by_solution: false,
      // Attemps will be not considered when offline
      remaining_attempts_html: null
    };
  }

  mumuki.runSolutionLocally = function (exerciseId, solution) {
    console.log('[Mumuki::Laboratory::OfflineRunner] Running solution...');

    const exercise = mumuki.ExercisesStore.find(exerciseId);

    let result = initialLocalResult();

    mumuki.localTestRunner.runTests(solution, exercise, result);
    mumuki.localExpectationsRunner.runExpectations(solution, exercise, result);

    console.log(`[Mumuki::Laboratory::OfflineRunner] Done. Status is ${result.status}...`)
    return Promise.resolve(result);
  };

  // Runners may call this function to set local test runners
  mumuki.registerLocalTestRunner = function (runner) {
    mumuki.localTestRunner = runner;
  };

  // Runners may call this function to set local expectation runners
  mumuki.registerLocalExpectationsRunner = function (runner) {
    mumuki.localExpectationsRunner = runner;
  };

  mumuki.load(() => {
    mumuki.registerLocalTestRunner(BasicLocalTestRunner)
    mumuki.registerLocalExpectationsRunner(MulangLocalExpectationsRunner)
  });
})();



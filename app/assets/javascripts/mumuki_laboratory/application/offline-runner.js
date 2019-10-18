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
    runExpectations(solution, exercise, result) {
      result.expectations_html = '';
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



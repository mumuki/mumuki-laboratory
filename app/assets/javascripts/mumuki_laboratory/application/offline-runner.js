(() => {
  const BasicLocalTestRunner = new class {
    runTests(solution, exercise, result) {
      result.status = "passed"; // FIXME hardcoded
      result.guide_finished_by_solution = false;
      result.html = "<div class=\"mu-kids-callout-danger\">  </div>  <img class=\"capital-animation mu-kids-corollary-animation\"/><div class=\"mu-last-box\"><p><p>Como ves, para que el tractor siembre lechuga, tenemos que decirle a Mukinita que ponga 2 bolitas verdes.  Y en este ejemplo acabamos de sembrar una hilera de 4 lechugas. </p><p>Pero fue un poco difícil entenderlo, ¿no? </p></p>        </div>      ",
      result.remaining_attempts_html = null;
      result.test_results = []
    }
  }

  const MulangLocalExpectationsRunner = new class {
    runExpectations(solution, exercise, result) {
      result.expectations_html = '';
    }
  }

  mumuki.runSolutionLocally = function (exerciseId, solution) {
    const exercise = mumuki.ExercisesStore.find(exerciseId);
    let result = {};
    mumuki.localTestRunner.runTests(solution, exercise, result);
    mumuki.localExpectationsRunner.runExpectations(solution, exercise, result);
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
    mumuki.registerLocalTestRunner(MulangLocalExpectationsRunner)
  });
})();



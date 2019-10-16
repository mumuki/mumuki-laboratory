(() => {
  mumuki.runSolutionLocally = function (exerciseId, solution) {
    const status = "passed"; // FIXME hardcoded
    const result = {
      "status": status,
      "guide_finished_by_solution": false,
      "html":"<div class=\"mu-kids-callout-danger\">  </div>  <img class=\"capital-animation mu-kids-corollary-animation\"/><div class=\"mu-last-box\"><p><p>Como ves, para que el tractor siembre lechuga, tenemos que decirle a Mukinita que ponga 2 bolitas verdes.  Y en este ejemplo acabamos de sembrar una hilera de 4 lechugas. </p><p>Pero fue un poco difícil entenderlo, ¿no? </p></p>        </div>      ",
      "expectations_html":"",
      "remaining_attempts_html":null,
      "test_results":[]
    };
    return Promise.resolve(result)
  }
});

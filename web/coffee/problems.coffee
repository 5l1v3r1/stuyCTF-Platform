renderProblemList = _.template($("#problem-list-template").remove().text())
renderProblem = _.template($("#problem-template").remove().text())

@ratingMetrics = ["Difficulty", "Enjoyment", "Educational Value"]
@ratingQuestion = {"Difficulty": "How difficult is this problem?", "Enjoyment": "Did you enjoy this problem?", "Educational Value": "How much did you learn while solving this problem?"}
@ratingChoices = {"Difficulty": ["Too easy", "", "A bit challenging", "", "Very hard"], "Enjoyment": ["Hated it!", "", "It was okay.", "", "Loved it!"], "Educational Value": ["Nothing at all","", "Something useful", "", "Learned a lot!"]}

@timeValues = ["5 minutes or less", "10 minutes", "20 minutes", "40 minutes", "1 hour", "2 hours", "3 hours", "4 hours", "5 hours", "6 hours", "8 hours", "10 hours", "15 hours", "20 hours", "30 hours", "40 hours or more"]

sanitizeMetricName = (metric) ->
  metric.toLowerCase().replace(" ", "-")

problems = {}

updateProblemModal = (pid) ->
  problem = $.grep(problems, (o) ->
    o.pid == pid;
  )[0]
  $("#problem-title").html(problem.name + " - " + problem.score)
  $("#problem-description").html(problem.description)
  $("#problem-hint").html(problem.hint)
  $("#problem-input").attr("data-pid", problem.pid)
  disabled = problem.solved ? true : false
  $("#problem-input").attr("disabled", disabled)
  $("#problem-submit").attr("disabled", disabled)

submitProblem = (e) ->
  e.preventDefault()
  input = $(e.target).find("input")
  apiCall "POST", "/api/problems/submit", {pid: input.data("pid"), key: input.val()}
  .done (data) ->
    if data['status'] is 1
      ga('send', 'event', 'Problem', 'Solve', 'Basic')
      loadProblems()
    else
      ga('send', 'event', 'Problem', 'Wrong', 'Basic')
    apiNotify data

loadProblems = ->
  apiCall "GET", "/api/problems"
  .done (data) ->
    switch data["status"]
      when 0
        apiNotify(data)
      when 1
        problems = data["data"]
      	# We want the score to be level with the title, but the title
	# is defined in a template. This solution is therefore a bit
	# of a hack.
        addScoreToTitle("#title")
        $("#problem-list-holder").html renderProblemList({
          problems: data.data,
          renderProblem: renderProblem,
          sanitizeMetricName: sanitizeMetricName
        })

        #Should solved problem descriptions still be able to be viewed?
        #$("li.disabled>a").removeAttr "href"

        $(".problem-hint").hide()
        $(".problem-submit").on "submit", submitProblem

        $('[data-toggle="tooltip"]').tooltip()

        $(".problem").on "click", (e) ->
          updateProblemModal($(this).data("pid"))

addScoreToTitle = (selector) ->
        apiCall "GET", "/api/team/score", {}
        .done (data) ->
          if data.data
            $(selector).children("#team-score").remove()
            $(selector).append("<span id='team-score' class='pull-right'>Score: " + data.data.score + "</span>")
$ ->
  loadProblems()

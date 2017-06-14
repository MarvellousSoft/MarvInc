return {
    title = "Keep going",
    text = [[
Well done.

Besides %pink% directions %end% , you can add another modifier to the %red% walk %end% command: a %green% value %end% . The test subject will then walk that many steps. This may sound worse than the original command, but it may be useful for precise robot walking.

Examples:
    - %red% walk %green% 5 %end%
    - %red% walk %pink% left %green% 10 %end%

Reply this email to start the experiment.

Keep up the good work, and carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto2',
    open_func =
        function()
            Util.findId('manual_tab'):changeCommand("walk1", "walk")
        end
}

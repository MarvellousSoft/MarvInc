local Mail = require 'classes.tabs.email'

return {
    title = "THEY USE PEOPLE",
    text = [[

]],
    author = "Diego Lorenzo Vega (vega@rtd.marv.com)",
    open_func = function()
        require('classes.opened_email').close()
        Mail.deleteAuthor("Diego Lorenzo Vega (vega@rtd.marv.com)")
        FX.full_static()
        LoreManager.puzzle_done.diego_died = true
        LoreManager.check_all()
    end
}

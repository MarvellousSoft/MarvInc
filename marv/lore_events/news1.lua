local Mail = require "classes.tabs.email"

local news = {}

-- tutorial is a fake puzzle
news.require_puzzles = {'tutorial'}
news.wait = 50

function news.run()
    Mail.new('news1')
end

return news

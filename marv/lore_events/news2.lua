local Mail = require "classes.tabs.email"

local news = {}

news.require_puzzles = {'act1'}
news.wait = 70

function news.run()
    Mail.new('news2')
end

return news

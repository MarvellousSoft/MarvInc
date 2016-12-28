## Lore Events

Lore events are triggered by completing puzzles. They should mainly be used to send new emails that add new puzzles.

To create a new Lore Event, create a .lua file in this folder, and it should return a table that has the following fields:
- require\_puzzles: A list of id's of puzzles that should be completed before this event is triggered.
- wait: number to seconds to wait after the puzzles are completed to be triggered (if nil it will default to 0)
- run: A function that will be called when the event is triggered

There is no need to add the name of the .lua file anywhere in the code, it is added automatically.

IMPORTANT: Please use LoreManager.timer for all your timer needs in Lore Events, do not use another timer or create your own. This is because all events 'on hold' need to be triggered when the game is being saved.

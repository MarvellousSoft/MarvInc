## Lore Events

Lore events are triggered by completing puzzles. They should mainly be used to send new emails that add new puzzles.

To create a new Lore Event, create a .lua file in this folder, and it should return a table that has the following fields:
- `wait`: number to seconds to wait after the puzzles are completed to be triggered (if `nil` it will default to `0`)
- `run`: A function that will be called when the event is triggered
- `require_puzzles`: A list of id's of puzzles that should be completed before this event is triggered, if it also contains an `at_least` field, then only those many puzzles are required to trigger the event. It may also be a list of lists of id's, in the same way.
    - Example: `{'tuto6', 'tuto7', at_least=1}` requires having completed at least one level between `tuto6` and `tuto7`.
    - Example: `{{'tuto3'}, {'tuto4', 'tuto5', at_least=1}}` requires having completed `tuto3` and at least one between `tuto4` and `tuto5`.

There is no need to add the name of the .lua file anywhere in the code, it is added automatically.

IMPORTANT: Please use `LoreManager.timer` for all your timer needs in Lore Events, do not use another timer or create your own. This is because all events 'on hold' need to be triggered when the game is being saved.

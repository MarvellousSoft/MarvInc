require "classes.primitive"

-- Puzzle stores the values for a new room.

Puzzle = Class{
    init = function(self)
        -- Declaring what the fields are (for readability).

        -- Puzzle name
        self.name = nil
        -- Puzzle number
        self.n = nil

        -- Puzzle object grid
        self.grid_obj = nil
        -- Puzzle floor grid
        self.grid_floor = nil

        -- Bot initial position
        self.init_pos = nil
        -- Bot initial orientation
        self.orient = nil

        -- Objectives
        self.objs = nil
    end
}

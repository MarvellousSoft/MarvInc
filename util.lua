--MODULE WITH LOGICAL, MATHEMATICAL AND USEFUL STUFF--

local util = {}

---------------------
--UTILITIES FUNCTIONS
---------------------

--Counts how many entries are on table T
function util.tableLen(T)
  local count = 0

  if not T then return count end
  for _ in pairs(T) do count = count + 1 end

  return count
end

--Chcks if a tale is empty (true if it doesn't exist)
function util.tableEmpty(T)

  if not T then return true end

  return not next(T)
end

function util.clearTimerTable(T, TIMER)

    if not T then return end --If table is empty
    --Clear T table
    for _, o in pairs (T) do
        TIMER:cancel(o)
    end

end

--Return a random element from a given table.
--You can give an optional table argument 'tp', so it only returns elements that share a type with the table strings
--Obs: if you provide a tp table, and there isn't any suitable element available, the program will be trapped here forever (FIX THIS SOMETIME)
function util.randomElement(T, tp)
    local e

    while not e do
        e = T[love.math.random(util.tableLen(T))] --Get random element

        --If tp table isn't empty, compare
        if not util.tableEmpty(tp) then
            for i, k in pairs(tp) do
                if k == e.tp then
                    return e
                end
            end
            e = nil
        end
    end

    return e
end

--------------
--FIND OBJECTS
--------------

--Find an object based on an id
function util.findId(id)
    return ID_TABLE[id]
end

--Find a set of objects based on a subtype
function util.findSbTp(subtp)
    return SUBTP_TABLE[subtp]
end

----------------------
--MANIPULATE OBJECTS--
----------------------

--Set an atribute 'att' in all elements in a given 'T' table to 'value'
function util.setAtributeTable(T, att, value)
  for o in pairs(T) do
    o[att] = value
  end
end

--Set an atribute 'att' from an element with a given 'id' to 'value'
function util.setAtributeId(id, att, value)
  for o in pairs(ID_TABLE) do
    if o.id == id then
      o[att] = value
      return
    end
  end
end

--Set an atribute 'att' in all element with a given subtype 'st' to 'value'
function util.setAtributeSubtype(st, att, value)
  for o in pairs(SUBTP_TABLE[st]) do
    o[att] = value
  end
end

--------------------
--UPDATE FUNCTIONS
--------------------

--Update all objects in a table
function util.updateTable(dt, T)

    if not T then return end
    for o in pairs(T) do
        if o.update then
            o:update(dt)
        end
    end

end

--Update all objects with a subtype sb
function util.updateSubTp(dt, sb)
    util.updateTable(dt, SUBTP_TABLE[sb])
end

--Update an object with an id
function util.updateId(dt, id)
    local o

    o = util.findId(id)

    if not o then return end

    o:update(dt)

end

--Update all timers
function util.updateTimers(dt)

    MAIN_TIMER.update(dt)

end


---------------------
--DESTROY FUNCTIONS--
---------------------

--Delete an object based on an id
function util.destroyId(id)
    if ID_TABLE[id] then ID_TABLE[id]:destroy() end
end

--Delete a set of objects based on a subtype
function util.destroySubtype(subtp)
    if SUBTP_TABLE[subtp] then
        for o in pairs(SUBTP_TABLE[subtp]) do
            o:destroy()
        end
    end
end

--Iterate through a table and destroys any element with the death flag on
function util.destroyTable(T)

    if not T then return end
    for o in pairs(T) do
        if o.death then o:destroy() end
    end

end

--Iterate through all elements with a subtype sb and destroy anything with the death flag on
function util.destroySubTp(sb)

    util.destroyTable(SUBTP_TABLE[sb])

end

--Destroy all objects in game that have the death flag set to true
function util.destroyAll()

    for T in pairs(SUBTP_TABLE) do
        util.destroySubTp(T)
    end

    for o in pairs(ID_TABLE) do
        util.destroyId(o)
    end

    for _, T in pairs(DRAW_TABLE) do
        util.destroyTable(T)
    end

end

--Destroys a single element if his death flag is on
function util.destroyId(id)
    local o

    o = ID_TABLE[id]
    if o and o.death then
         o:destroy()
    end

end

---------------------
--UTILITY FUNCTIONS--
---------------------

--Exit program
function util.exit()

    love.event.quit()

end

--Toggle debug mode
function util.toggleDebug()

    DEBUG = not DEBUG
    print("DEBUG is", DEBUG)

end

--------------------
--GLOBAL FUNCTIONS--
--------------------

--Get any key that is pressed and checks for generic events
function util.defaultKeyPressed(key)

    if  key == 'escape' then
        util.exit()
    elseif key == 'f1' then
        util.toggleDebug()
    end

end

--Return functions
return util

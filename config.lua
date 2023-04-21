Config = {}

Config.CurrentResourceName = "jasper-blip-creator" -- Do not change => If the name of the script is changed, the script will not be executed(Runed)
Config.FrameWork = "ESX" -- Only support => QBCORE(qb-core) and ESX

---- (Command) ----
Config.CommandName = {
    added = "createblip",
    removed = "removeblip",
    show = "showblips"
}

---- (whiteList Check) ----
Config.whiteListCheck = false
Config.correctData = {
    colour = {[0] = true, [1] = true},
    sprite = {[1] = true, [2] = true},
    maxScale = 5.0
}

---- (Set Blip Display) ----
Config.defualtData = {
    -- displayBlip = -1, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
    scale = 1,
    colour = 1, -- https://docs.fivem.net/docs/game-references/blips/
    sprite = 1, -- https://docs.fivem.net/docs/game-references/blips/
    shortRange = true,
    name = "Jasper Blip Creator",
}

---- (Notify Message Text) ----
Config.Message = {
    empty_sprite = "You ~r~didn't write ~w~anything in the ~b~Sprite~w~ section.",
    empty_id = "You ~r~didn't write ~w~anything in the ~b~ID~w~ section.",
    empty_colour = "You ~r~didn't write ~w~anything in the ~b~Colour~w~ section.",
    empty_shortRange = "You ~r~didn't write ~w~anything in the ~b~ShortRange~w~ section.",
    empty_scale = "You ~r~didn't write ~w~anything in the ~b~Scale~w~ section.",
    empty_name = "You ~r~didn't write ~w~anything in the ~b~Name~w~ section.",
    number_type = "You need to enter a ~g~number~w~ in this section.",
    boolean_type = "You need to enter a ~g~boolean(true/false)~w~ in this section.",
    string_type = "You need to enter a ~g~string('Jasper Blip Creator')~w~ in this section.",
    not_in_whlist = "Your input items are ~r~not~w~ in the ~b~whitelist~w~.",
    removed_blip = "Bleep with ~o~ID:%s~w~ has been ~r~removed~w~ successfully.",
    added_blip = "Successfully ~g~added~w~ Bleep with ~o~ID:%s~w~.",
    not_exist_blip = "The blip with ~o~ID:%s~w~ does not exist."
}

---- (Custom Notify) ---- 
Config.sendCustomNotif = false -- send custom notif or message
Config.CustomNotif = function(message, source) -- source == true => server send
    if source then
        -- Your Code:
        --TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, message)
    else
        -- Your Code:
        --TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0" .. message}})
    end
end
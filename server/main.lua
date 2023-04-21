local ESX = nil
local QBCore = nil

local blipsData = json.decode(LoadResourceFile(GetCurrentResourceName(), "./data/blips.json"))

local blips = blipsData.blips
local blipIdC = blipsData.id

local frameWork = Config.FrameWork

if frameWork == "QBCORE" then
	QBCore = exports["qb-core"]:GetCoreObject()
elseif frameWork == "ESX" then
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

---@diagnostic disable-next-line: missing-parameter
RegisterCommand(Config.CommandName.added, function(source, args) -- /createblip [sprite] [colour] [shortRange] [scale] [name] [displayBlip]

	local sprite = tonumber(args[1])
	if args[1] == nil then return sendNotify(source, Config.Message.empty_sprite) end
	if sprite == nil or not type(sprite) == "number" then return sendNotify(source, Config.Message.number_type) end

	local colour = tonumber(args[2])
	if args[2] == nil then return sendNotify(source, Config.Message.empty_colour) end
	if colour == nil or not type(colour) == "number" then return sendNotify(source, Config.Message.number_type) end

	local shortRange = toboolean(args[3])
	if args[3] == nil then return sendNotify(source, Config.Message.empty_shortRange) end
	if shortRange == nil or not type(shortRange) == "boolean" then return sendNotify(source, Config.Message.boolean_type) end

	local scale = tonumber(args[4])
	if args[4] == nil then return sendNotify(source, Config.Message.empty_scale) end
	if scale == nil or not type(scale) == "number" then return sendNotify(source, Config.Message.number_type) end

	local name = args[5]
	if args[5] == nil then return sendNotify(source, Config.Message.empty_name) end
	if not type(name) == "string" then return sendNotify(source, Config.Message.string_type) end

	local displayBlip = tonumber(args[6])
	if not args[6] then displayBlip = false end
	if args[6] and not type(displayBlip) == "number" then return sendNotify(source, Config.Message.number_type) end

	if Config.whiteListCheck then
		local correctData = Config.correctData
		if (not correctData.sprite[sprite]) or (not correctData.colour[colour]) or (not scale <= correctData.scale) then return sendNotify(source, Config.Message.not_in_whlist) end
	end

	if frameWork == "QBCORE" then
		local player = QBCore.Functions.GetPlayer(source)
		if not player then return end

		-- Code
	elseif frameWork == "ESX" then
		local xPlayer = ESX.GetPlayerFromId(source)
		if not xPlayer then return end

		-- Code
	end

	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)

	blipIdC += 1
	blipsData.id = blipIdC

	blips[blipIdC] = {id = blipIdC, sprite = sprite, colour = colour, displayBlip = displayBlip, shortRange = shortRange, scale = scale + 0.0, name = name, coords = coords}

	TriggerClientEvent('jasper-blip-creator:addBlip', -1, blips[blipIdC])
	SaveResourceFile(GetCurrentResourceName(), "data/blips.json", json.encode(blipsData), -1)
	sendNotify(source, Config.Message.added_blip:format(blipIdC))
end)

---@diagnostic disable-next-line: missing-parameter
RegisterCommand(Config.CommandName.removed, function(source, args)
	local id = tonumber(args[1])
	if args[1] == nil then return sendNotify(source, Config.Message.empty_id) end
	if id == nil or not type(id) == "number" then return sendNotify(source, Config.Message.number_type) end

	if blips[id] then
		blips[id] = nil
		SaveResourceFile(GetCurrentResourceName(), "data/blips.json", json.encode(blipsData), -1)
		TriggerClientEvent('jasper-blip-creator:removeBlip', -1, id)
		sendNotify(source, Config.Message.removed_blip:format(id))
	else
		sendNotify(source, Config.Message.not_exist_blip:format(id))
	end
end)


---@diagnostic disable-next-line: missing-parameter
RegisterCommand(Config.CommandName.show, function(source)
	for _, blip in pairs(blips) do
		if blip.id then
			TriggerClientEvent('chatMessage', source, "[Jasper Blip System]", {255, 0, 0}, ("^9Blip ID: ^0%s, ^9Blip Name:^0 %s"):format(blip.id, blip.name))
		end
	end
end)

function toboolean(string)
    local bool = nil

    if string == "true" then
        bool = true
	elseif string == "false" then
        bool = false
    end

    return bool
end

function sendNotify(source, message)
	if not Config.sendCustomNotif then
		if frameWork == 'ESX' then
			TriggerClientEvent('esx:showNotification', source, message)
		elseif frameWork == 'QBCORE' then
			QBCore.Functions.Notify(source, message, "primary")
		end
	else
		Config.CustomNotif(message, source)
	end
end

AddEventHandler('esx:playerLoaded', function(source)
	local src = source
	if not src then return end

	TriggerClientEvent('jasper-blip-creator:loadBlips', src, blips)
end)
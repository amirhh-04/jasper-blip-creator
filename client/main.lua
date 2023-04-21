local ESX = nil
local QBCore = nil
local blips = {}

local PlayerData = {}
local PlayerJob = {}

local frameWork = Config.FrameWork

if frameWork == 'ESX' then
    Citizen.CreateThread(function()
        while not ESX do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end

        while not ESX.GetPlayerData().job do
            Citizen.Wait(10)
        end

        PlayerData = ESX.GetPlayerData()
    end)
elseif frameWork == 'QBCORE' then
    QBCore = exports['qb-core']:GetCoreObject()
    PlayerData = QBCore.Functions.GetPlayerData()
end

RegisterNetEvent('jasper-blip-creator:loadBlips')
AddEventHandler('jasper-blip-creator:loadBlips', function(data)
    Citizen.CreateThread(function()
        for _, blip in pairs(data) do
            addBlip(blip)
        end
    end)
end)

RegisterNetEvent("jasper-blip-creator:addBlip")
AddEventHandler("jasper-blip-creator:addBlip", function(data)
    addBlip(data)
end)


RegisterNetEvent('jasper-blip-creator:removeBlip')
AddEventHandler('jasper-blip-creator:removeBlip', function(id)
    local blip = blips[id]
    if not blip then return end

    if DoesBlipExist(blip.blip) then RemoveBlip(blip.blip) end

    blips[id] = nil
end)

function addBlip(newBlip)
    if blips[newBlip.id] then return end

    local defData = Config.defualtData
    local blip = AddBlipForCoord(newBlip.coords.x, newBlip.coords.y, newBlip.coords.z)

    SetBlipSprite(blip, newBlip.sprite or defData.sprite)
    SetBlipColour(blip, newBlip.colour or defData.colour)
    SetBlipScale(blip, newBlip.scale or defData.scale)
    SetBlipAsShortRange(blip, newBlip.shortRange or defData.shortRange)

    if defData.displayBlip and newBlip.displayBlip and newBlip.displayBlip > -1 then
        SetBlipDisplay(blip, newBlip.displayBlip)
    end

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(newBlip.name or defData.name)
    EndTextCommandSetBlipName(blip)
    blips[newBlip.id] = newBlip
    blips[newBlip.id].blip = blip
end

function sendNotify(message)
    if not Config.sendCustomNotif then
        if frameWork == 'ESX' then
            ESX.ShowNotification(message)
        elseif frameWork == 'QBCORE' then
            QBCore.Functions.Notify(message, "primary")
        end
    else
        Config.CustomNotif(message)
    end
end

TriggerEvent('chat:addSuggestion', "/" .. Config.CommandName.added, 'Create Blip', {
    { name="sprite", help="set blip number(0-...)" },
    { name="colour", help="set blip colour(0-...)" },
    { name="shortRange", help="set short Range(true, false)" },
    { name="scale", help="set Blip scale(0.1-...)" },
    { name="name", help="blip name('Jasper')" },
    { name="displayBlip", help="displayBlip(0-...)" }
})

TriggerEvent('chat:addSuggestion', "/" .. Config.CommandName.removed, 'Remove Blip', {
    { name="id", help="blip id" }
})

TriggerEvent('chat:addSuggestion', "/" .. Config.CommandName.show, 'Show All Blips', {})

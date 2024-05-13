local vendModel = joaat('sf_prop_sf_vend_drink_01a')

local function setVendingTargets()
    Target.addModel(vendModel, { {
        label = 'Open Junk Machine',
        name = 'junkvendingmenu',
        icon = 'fas fa-bottle-water',
        distance = 1,
        onSelect = function()
            -- junk menu
        end
    } })
end

function SetVendingMachines()
    lib.requestModel(vendModel)
    for i = 1, #Cfg.VendingMachines.Locations do
        local machine = CreateObject(vendModel, Cfg.VendingMachines.Locations[i].x, Cfg.VendingMachines.Locations[i].y, Cfg.VendingMachines.Locations[i].z, false, false, false)
        SetEntityHeading(machine, Cfg.VendingMachines.Locations[i].w)
        FreezeEntityPosition(machine, true)
    end
    setVendingTargets()
end

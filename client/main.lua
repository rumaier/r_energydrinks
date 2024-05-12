local vendModel = joaat(`sf_prop_sf_vend_drink_01a`)

function SetVendingMachines()
    lib.requestModel(vendModel)
    for i = 1, #Cfg.VendingMachines.Locations do
        print(i)
    end
end

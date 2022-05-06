Config = {}

-- Job

Config.DutyZone = {
    name = "duty_zone_1",
    coords = vector4(2441.9, 4984.68, 46.81, 38.18),
    width = 3.0,
    height = 3.0,
    debug = false 
}

Config.TractorZone = {
    name = "tractor_zone_1",
    coords = vector4(2413.84, 4991.25, 46.24, 314.09),
    width = 15.0,
    height = 5.0,
    debug = false
}

Config.StashZone = {
    name = "stash_zone_1",
    coords = vector4(2310.42, 4884.8, 41.81, 223.01),
    width = 1.0,
    height = 1.0,
    debug = false
}

-- Weath

Config.WeathGainMin = 3
Config.WeathGainMax = 6
Config.WeathSeedGainChance = 46

Config.WeathZone = {
    [1] = { name = "weath_zone_1", coords = vector4(2308.50, 5125.00, 52.19, 225.00), width = 85.0, height = 55.0, debug = false }
}

Config.Weath = {
    [1] = { coords = vector3(2296.46, 5167.24, 57.97), isPlanted = false },
    [2] = { coords = vector3(2302.09, 5161.93, 56.14), isPlanted = false },
    [3] = { coords = vector3(2306.71, 5156.77, 54.59), isPlanted = false },
    [4] = { coords = vector3(2312.1, 5151.58, 53.06), isPlanted = false },
    [5] = { coords = vector3(2317.78, 5146.24, 51.71), isPlanted = false },
    [6] = { coords = vector3(2323.05, 5141.1, 50.49), isPlanted = false },
    [7] = { coords = vector3(2328.31, 5135.97, 49.64), isPlanted = false },
    [8] = { coords = vector3(2334.96, 5129.57, 48.77), isPlanted = false },
    [9] = { coords = vector3(2339.57, 5124.64, 48.37), isPlanted = false },
    [10] = { coords = vector3(2345.09, 5119.16, 48.28), isPlanted = false },
    [11] = { coords = vector3(2290.01, 5159.97, 56.66), isPlanted = false },
    [12] = { coords = vector3(2295.44, 5154.52, 54.95), isPlanted = false },
    [13] = { coords = vector3(2300.51, 5149.22, 53.57), isPlanted = false },
    [14] = { coords = vector3(2306.87, 5142.86, 52.06), isPlanted = false },
    [15] = { coords = vector3(2311.75, 5137.95, 51.02), isPlanted = false },
    [16] = { coords = vector3(2316.52, 5133.32, 50.08), isPlanted = false },
    [17] = { coords = vector3(2321.45, 5128.83, 49.34), isPlanted = false },
    [18] = { coords = vector3(2325.84, 5124.28, 48.64), isPlanted = false },
    [19] = { coords = vector3(2330.64, 5119.68, 48.19), isPlanted = false },
    [20] = { coords = vector3(2335.62, 5114.63, 47.82), isPlanted = false },
    [21] = { coords = vector3(2340.36, 5109.87, 47.81), isPlanted = false },
}

-- Tomato

Config.TomatoGainMin = 2
Config.TomatoGainMax = 4

Config.TomatoZone = {
    [1] = { name = "tomato_zone_1", coords = vector4(2259.96, 4772.72, 45.01, 343.62), width = 30.0, height = 75.0, debug = false }
}

Config.Tomato = {
    [1] = { coords = vector3(2285.32, 4772.06, 38.75), isPlanted = false },
    [2] = { coords = vector3(2283.3, 4762.06, 38.97), isPlanted = false },
}

-- Mission Livery

Config.PngDebug = true

Config.LiveryMin = 10
Config.LiveryMax = 50

Config.PngLocationNumber = 3

Config.PngLocation = {
    [1] = { coords = vector4(2432.57, 4993.38, 46.24, 209.22), model = "s_m_m_migrant_01", item = "tomato", itemName = "Tomate", price = 10 },
    [2] = { coords = vector4(2432.57, 4993.38, 46.24, 209.22), model = "s_m_m_migrant_01", item = "tomato", itemName = "Tomate", price = 10 },
    [3] = { coords = vector4(2432.57, 4993.38, 46.24, 209.22), model = "s_m_m_migrant_01", item = "tomato", itemName = "Tomate", price = 10 },
}
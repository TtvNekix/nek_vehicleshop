Config = {}
Config['Version'] = 1.9 -- DON'T TOUCH THIS

Config['EnableWebhook'] = false
Config['Webhook'] = "" -- Change me compulsory
Config['CommunityName'] = "Nekix Vehicle Shop Logs" -- Change me if you want
Config['CommunityLogo'] = 'https://cdn.discordapp.com/icons/838115320597446677/a96dc72395659c8d3921bece0ac2039d?size=256' -- Change me if you want
Config['Avatar'] = 'https://cdn.discordapp.com/icons/838115320597446677/a96dc72395659c8d3921bece0ac2039d?size=256' -- Change me if you want

Config['VS'] = {
    ['PressKey'] = 38, -- E
    ['NeedLicense'] = false, -- Need license? Dependency --> esx_license
    ['LicenseRequired'] = 'drive', -- Only if ['NeedLicense'] is true
    ['Menu'] = {
        {label = "Pagar en Efectivo", value = 'money'},
        {label = "Pagar con Tarjeta", value = 'bank'}
    },
    ['Cars'] = {
        {
            ['model'] = 'blista',
            ['label'] = "Blista",
            ['price'] = 1,
            ['x'] = 227.5898,
            ['y'] = -873.8725,
            ['z'] = 30.4921,
            ['r'] = -12.9241,
        },
    },
    ['Spawn'] = {
        {
            ['x'] = 222.1689,
            ['y'] = -852.3805,
            ['z'] = 30.06906,
            ['r'] = -110.8709
        }
    }
}

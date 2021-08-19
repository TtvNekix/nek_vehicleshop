Config = {}
Config['Version'] = 1.0 -- DON'T TOUCH THIS

Config['Webhook'] = "https://discord.com/api/webhooks/876878318467710987/rEKvsrQyAMEleE5fcdF1P4VwyqVaXFi_UUZs6xv_HdPB_1tUHz29oVkHJNsyUpPhXUGf" -- Change me compulsory
Config['CommunityName'] = "Nekix Vehicle Shop Logs" -- Change me if you want
Config['CommunityLogo'] = 'https://cdn.discordapp.com/icons/838115320597446677/a96dc72395659c8d3921bece0ac2039d?size=256' -- Change me if you want
Config['Avatar'] = 'https://cdn.discordapp.com/icons/838115320597446677/a96dc72395659c8d3921bece0ac2039d?size=256' -- Change me if you want

Config['VS'] = {
    ['PressKey'] = 38, -- E
    ['Menu'] = {
        {label = "Pagar en Efectivo", value = 'money'},
        {label = "Pagar con Tarjeta", value = 'bank'}
    },
    ['Cars'] = {
        {
            ['model'] = 'blista',
            ['label'] = "Blista",
            ['price'] = 100,
            ['x'] = 227.5898,
            ['y'] = -873.8725,
            ['z'] = 30.4921,
            ['r'] = -12.9241,
        },
        {
            ['model'] = 't20',
            ['label'] = "T20",
            ['price'] = 200,
            ['x'] = 231.7252,
            ['y'] = -875.0043,
            ['z'] = 30.49209,
            ['r'] = -13.36321,
        },
        {
            ['model'] = 'kuruma2',
            ['label'] = "Kuruma Blindado",
            ['price'] = 300,
            ['x'] = 237.0032,
            ['y'] = -876.5366,
            ['z'] = 30.49211,
            ['r'] = -13.97616,
        },
    }
}
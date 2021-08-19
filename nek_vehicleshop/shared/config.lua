Config = {}
Config['Version'] = 1.1 -- DON'T TOUCH THIS
Config['EnableWebhook'] = true

Config['Webhook'] = "https://discord.com/api/webhooks/878027900643835955/ubEpGZdx4ekmw1aPryCcAbtiUU_DrqFk77rueVfetG5a6_YgNnZPeKi33yVXc1vpnY5E" -- Change me compulsory
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
            ['model'] = 'kuruma',
            ['label'] = "Kuruma",
            ['price'] = 500,
            ['x'] = 233.2888,
            ['y'] = -875.6024,
            ['z'] = 30.49209,
            ['r'] = -13.57896,
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

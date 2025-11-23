mod.DressScreenData = {
    DressSelector = {
        Components = {},
        OpenSound = "/SFX/Menu Sounds/HadesLocationTextAppear",
        Name = "DressSelector",
        RowStartX = -(ScreenCenterX * 0.65),
        RowStartY = -(ScreenCenterY * 0.5),
        ComponentData = {
            DefaultGroup = "Combat_Menu_TraitTray_Backing",
            UseNativeScreenCenter = true,

            BackgroundTint =
            {
                Graphic = "rectangle01",
                GroupName = "Combat_Menu_TraitTray_Backing",
                Scale = 10,
                X = ScreenCenterX,
                Y = ScreenCenterY,
            },

            Background =
            {
                Graphic = "Box_FullScreen",
                GroupName = "Combat_Menu_TraitTray",
                X = ScreenCenterX,
                Y = ScreenCenterY,
                Scale = 1.15,
                Text = "Select Dress",
                TextArgs =
                {
                    FontSize = 32,
                    Width = 750,
                    OffsetY = -(ScreenCenterY * 0.825),
                    Color = Color.White,
                    Font = "P22UndergroundSCHeavy",
                    ShadowBlur = 0,
                    ShadowColor = { 0, 0, 0, 0 },
                    ShadowOffset = { 0, 3 },
                },

                Children = {
                    CloseButton =
                    {
                        Graphic = "ButtonClose",
                        GroupName = "Combat_Menu_TraitTray",
                        Scale = 0.7,
                        OffsetX = 0,
                        OffsetY = 510,
                        Data =
                        {
                            OnPressedFunctionName = _PLUGIN.guid .. '.' .. 'CloseDressSelector',
                            ControlHotkeys = { "Cancel", },
                        },
                    },
                }
            }
        }
    }
}

mod.DressCommandData = {
    IconPath = "GUI\\Screens\\BoonIcons\\Arachne_01",
    IconScale = 0.5,
    Name = "Select Dress",
    Description = "Choose from all the dresses Arachne can give plus the Nightmare form",
    Type = "Command",
    Function = _PLUGIN.guid .. '.' .. "OpenDressSelector"
}
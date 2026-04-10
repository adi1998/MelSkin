mod.DressScreenData = {
    DressSelector = {
        Components = {},
        OpenSound = "/SFX/Menu Sounds/HadesLocationTextAppear",
        Name = "DressSelector",
        RowStartX = -(game.ScreenCenterX * 0.65),
        RowStartY = -(game.ScreenCenterY * 0.5),
        BlockPause = true,
        ComponentData = {
            DefaultGroup = "Combat_Menu_TraitTray_Backing",
            UseNativeScreenCenter = true,

            BackgroundTint =
            {
                Graphic = "",
                GroupName = "Combat_Menu_TraitTray_Backing",
                Scale = 10,
                X = game.ScreenCenterX,
                Y = game.ScreenCenterY,
            },

            Background =
            {
                Graphic = "MelSkin_Box_Preview",
                GroupName = "Combat_Menu_TraitTray",
                X = game.ScreenCenterX,
                Y = game.ScreenCenterY,
                Scale = 1,
                Text = "Select Dress",
                TextArgs =
                {
                    FontSize = 32,
                    Width = 750,
                    OffsetY = -(game.ScreenCenterY * 0.825),
                    Color = game.Color.White,
                    Font = "P22UndergroundSCHeavy",
                    ShadowBlur = 0,
                    ShadowColor = { 0, 0, 0, 0 },
                    ShadowOffset = { 0, 3 },
                },

                Children = {

                    RandomDressButton =
                    {
                        Name = "ButtonDefault",
                        Group = "Combat_Menu_TraitTray",
                        Scale = 1.2,
                        ScaleX = 1.6,
                        OffsetX = 0,
                        OffsetY = 420,
                        Text = "Randomize Dress Each Run",
                        TextArgs =
                        {
                            FontSize = 22,
                            Width = 720,
                            Color = game.Color.White,
                            Font = "P22UndergroundSCMedium",
                            ShadowBlur = 0,
                            ShadowColor = { 0, 0, 0, 1 },
                            ShadowOffset = { 0, 2 },
                            Justification = "Center"
                        },
                        Data = {
                            OnPressedFunctionName = _PLUGIN.guid .. '.' .. 'ToggleRandomDressSelection',
                            RandomButtonId = "RandomButtonId"
                        },
                    },

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

                    SelectButton =
                    {
                        Graphic = "ContextualActionButton",
                        GroupName = "Combat_Menu_TraitTray",
                        Alpha = 1,
                        OffsetY = 420,
                        OffsetX = 440,
                        Data =
                        {
                            -- For display only
                            OnMouseOverFunctionName = "MouseOverContextualAction",
                            OnMouseOffFunctionName = "MouseOffContextualAction",
                        },
                        Text = "{SL} Select",
                        TextArgs = game.UIData.ContextualButtonFormatRight,
                    },

                    FavoriteButton =
                    {
                        Graphic = "ContextualActionButton",
                        GroupName = "Combat_Menu_TraitTray",
                        Alpha = 1,
                        OffsetY = 420,
                        OffsetX = 805,
                        Data =
                        {
                            -- Hotkey only
                            OnMouseOverFunctionName = "MouseOverContextualAction",
                            OnMouseOffFunctionName = "MouseOffContextualAction",
                            OnPressedFunctionName = _PLUGIN.guid .. '.' .. "ToggleFavriteDressSelection",
                            ControlHotkeys = { "ItemPin" }
                        },
                        Text = "{IP} Add/Remove Favorite",
                        TextArgs = game.UIData.ContextualButtonFormatRight,
                    },

                    ResetFavoriteButton =
                    {
                        Graphic = "ContextualActionButton",
                        GroupName = "Combat_Menu_TraitTray",
                        Alpha = 1,
                        OffsetY = 420,
                        OffsetX = -820,
                        Data =
                        {
                            OnMouseOverFunctionName = "MouseOverContextualAction",
                            OnMouseOffFunctionName = "MouseOffContextualAction",
                            OnPressedFunctionName = _PLUGIN.guid .. "." .. "ResetFavorites",
                            ControlHotkeys = { "MenuLeft" },
                        },
                        Text = "{ML} Reset Favorites",
                        TextArgs = game.UIData.ContextualButtonFormatLeft,
                    },
                    SelectAllFavoriteButton =
                    {
                        Graphic = "ContextualActionButton",
                        GroupName = "Combat_Menu_TraitTray",
                        Alpha = 1,
                        OffsetY = 420,
                        OffsetX = -530,
                        Data =
                        {
                            OnMouseOverFunctionName = "MouseOverContextualAction",
                            OnMouseOffFunctionName = "MouseOffContextualAction",
                            OnPressedFunctionName = _PLUGIN.guid .. "." .. "FavoriteAll",
                            ControlHotkeys = { "MenuRight" },
                        },
                        Text = "{MR} Favorite All",
                        TextArgs = game.UIData.ContextualButtonFormatLeft,
                    }
                }
            }
        }
    }
}

mod.DressCommandData = {
    IconPath = "GUI\\Screens\\BoonIcons\\Arachne_01",
    IconScale = 0.5,
    Name = "Select Dress",
    Description = "Choose from all the dresses Arachne can give plus some more",
    Type = "Command",
    Function = _PLUGIN.guid .. '.' .. "OpenDressSelector"
}
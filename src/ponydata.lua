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
                            Color = Color.White,
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

                    FavoriteButton = 
                    {
                        Graphic = "ContextualActionButton",
                        GroupName = "Combat_Menu_TraitTray",
                        Alpha = 1,
                        OffsetY = 420,
                        OffsetX = 800,
                        Data =
                        {
                            -- Hotkey only
                            OnMouseOverFunctionName = "MouseOverContextualAction",
		                    OnMouseOffFunctionName = "MouseOffContextualAction",
                            OnPressedFunctionName = _PLUGIN.guid .. '.' .. "ToggleFavriteDressSelection",
                            ControlHotkeys = { "ItemPin" }
                        },
                        Text = "{IP} Add/Remove Favorite",
                        TextArgs = UIData.ContextualButtonFormatRight,
                    },

                    ResetFavoriteButton =
                    {
                        Graphic = "ContextualActionButton",
                        GroupName = "Combat_Menu_TraitTray",
                        Alpha = 1,
                        OffsetY = 420,
                        OffsetX = -800,
                        Data =
                        {
                            -- Hotkey only
                            OnMouseOverFunctionName = "MouseOverContextualAction",
		                    OnMouseOffFunctionName = "MouseOffContextualAction",
                            OnPressedFunctionName = _PLUGIN.guid .. "." .. "ResetFavorites",
                            ControlHotkeys = { "MenuLeft" },
                        },
                        Text = "{ML} Reset Favorites",
                        TextArgs = UIData.ContextualButtonFormatLeft,
                    },
                    SelectAllFavoriteButton =
                    {
                        Graphic = "ContextualActionButton",
                        GroupName = "Combat_Menu_TraitTray",
                        Alpha = 1,
                        OffsetY = 420,
                        OffsetX = -500,
                        Data =
                        {
                            -- Hotkey only
                            OnMouseOverFunctionName = "MouseOverContextualAction",
		                    OnMouseOffFunctionName = "MouseOffContextualAction",
                            OnPressedFunctionName = _PLUGIN.guid .. "." .. "FavoriteAll",
                            ControlHotkeys = { "MenuRight" },
                        },
                        Text = "{MR} Favorite All",
                        TextArgs = UIData.ContextualButtonFormatLeft,
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
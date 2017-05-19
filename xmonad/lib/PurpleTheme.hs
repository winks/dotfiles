module PurpleTheme (purpleTheme, purpleXPConfig) where

-- adapted from https://github.com/datagrok/home

import XMonad.Util.Themes(theme, listOfThemes)
import XMonad.Layout.Decoration
import XMonad.Prompt

--purpleTheme       = theme $ listOfThemes!!2     -- I like the second theme in the list.
purpleXPConfig    = themedXPConfig purpleTheme

-- I want a single point of configuration for theme-related things. This
-- creates an XPConfig (a configuration for xprompt) from a theme.
-- Unfortunately, changing the theme 'live' with themePrompt affects only the
-- window decorations, not the prompts. Don't know how that works yet. TODO
themedXPConfig :: Theme -> XPConfig
themedXPConfig t = def
    { font              = fontName t
    , bgColor           = inactiveColor t
    , fgColor           = inactiveTextColor t
    , fgHLight          = activeTextColor t
    , bgHLight          = activeColor t
    , borderColor       = inactiveBorderColor t
    , height            = decoHeight t
    , promptBorderWidth = 1
    , position          = Bottom
    , historySize       = 256
    , defaultText       = []
    , autoComplete      = Nothing
    }

purpleTheme = def
    { activeBorderColor   = "#5f9ea0"
    , activeTextColor     = "#87cefa"
    , activeColor         = "#602060"
    , inactiveBorderColor = "#708090"
    , inactiveTextColor   = "#888888"
    , inactiveColor       = "#333333"
    , decoHeight          = 24
    , fontName            = "xft:Fantasque Sans Mono:size=10,Sans:size=10:antialias=true"
    }

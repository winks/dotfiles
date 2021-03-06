-- WTF - Was taete fpletz?
import XMonad
import XMonad.Operations

import Graphics.X11.Xlib

import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Data.Ratio ((%))

import XMonad.ManageHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Layout
import XMonad.Layout.Decoration
import XMonad.Layout.ResizableTile
import XMonad.Layout.IM
--import XMonad.Layout.IMExtra
import XMonad.Layout.LayoutModifier
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Reflect
import XMonad.Layout.DwmStyle
import XMonad.Layout.TwoPane
import XMonad.Layout.ComboP
import XMonad.Layout.Column
import XMonad.Layout.Grid

import XMonad.Prompt
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Theme

import XMonad.Actions.CycleWS
import XMonad.Actions.UpdatePointer

import XMonad.Util.Run
import XMonad.Util.Scratchpad
import XMonad.Util.Themes
import XMonad.Util.WindowProperties

import XMonad.Actions.NoBorders
import XMonad.Actions.DynamicWorkspaces
import qualified XMonad.Actions.FlexibleResize as Flex

import XMonad.Layout.WindowArranger

import System.IO

import XMonad.Hooks.ManageHelpers
import Control.Monad
import Data.Monoid (All (All))

import BlueTheme(blueTheme, blueXPConfig)
import PurpleTheme(purpleTheme, purpleXPConfig)

--currentTheme = purpleTheme
--currentXPConfig = purpleXPConfig
--xm1 = "#220022"
--xm2 = "#00ff00"

currentTheme = blueTheme
currentXPConfig = defaultXPConfig
xm1 = "#2da5fa"
xm2 = "#1f72ac"

xmobarTitleLength = 80

ws_shell = "sh"
ws_code  = "code"
ws_www   = "www"
ws_im    = "im"
ws_mail  = "@"
ws_elev  = "☹"
ws_stuff = "♨"
ws_music = "♫"
ws_last  = "♥"

-- Helper functions to fullscreen the window
fullFloat, tileWin :: Window -> X ()
fullFloat w = windows $ W.float w r
    where r = W.RationalRect 0 0 1 1
tileWin w = windows $ W.sink w

evHook :: Event -> X All
evHook (ClientMessageEvent _ _ _ dpy win typ dat) = do
  state  <- getAtom "_NET_WM_STATE"
  fullsc <- getAtom "_NET_WM_STATE_FULLSCREEN"
  isFull <- runQuery isFullscreen win

  -- Constants for the _NET_WM_STATE protocol
  let remove = 0
      add    = 1
      toggle = 2

      -- The ATOM property type for changeProperty
      ptype  = 4
      action = head dat

  when (typ == state && (fromIntegral fullsc) `elem` tail dat) $ do
    when (action == add || (action == toggle && not isFull)) $ do
         io $ changeProperty32 dpy win state ptype propModeReplace [fromIntegral fullsc]
         fullFloat win
    when (head dat == remove || (action == toggle && isFull)) $ do
         io $ changeProperty32 dpy win state ptype propModeReplace []
         tileWin win

  -- It shouldn't be necessary for xmonad to do anything more with this event
  return $ All False

evHook _ = return $ All True

main = do
    xmobar <- spawnPipe ( "/usr/bin/xmobar" )
    xmonad $ myConfig xmobar

-- ⌨  ⎆ ✇ ☘  ⌬ ⌛ ☣ ⚔ ✨   😈  😏  😒
myConfig h = withUrgencyHook NoUrgencyHook $ defaultConfig
       { borderWidth        = 1
       , terminal           = "/usr/bin/x-terminal-emulator"
       , workspaces         = [ws_shell, ws_code, ws_www, ws_im, ws_mail, ws_elev, ws_stuff, ws_music, ws_last]
       , modMask            = mod4Mask
       , normalBorderColor  = "#ccc"
       , focusedBorderColor = "#05c"
       , focusFollowsMouse  = True
       , logHook            = (dynamicLogWithPP $ myPP h) >> updatePointer (0.5, 0.5) (1, 1)
       , keys               = \c -> myKeys c `M.union` keys defaultConfig c
       , mouseBindings      = myMouseBindings
       , manageHook         = manageDocks <+> manageHook defaultConfig <+> myManageHook
       , layoutHook         = myLayouts
       , handleEventHook    = evHook
       , startupHook        = myStartupHook
       }
  where
    myStartupHook = do
                    setWMName "LG3D"
                    spawn("/home/florian/bin/autoexec.bat")

    myKeys (XConfig {modMask = modm}) = M.fromList $
      -- rotate workspaces
      [ ((modm .|. controlMask, xK_Right), nextWS)
      , ((modm .|. controlMask, xK_Left ), prevWS)

      -- switch to previous workspace
      , ((modm,                 xK_z    ), toggleWS)
      , ((modm .|. shiftMask,   xK_b    ), withFocused toggleBorder)

      -- lock the screen with xtrlock
      , ((modm .|. shiftMask,   xK_l    ), spawn "xlock")
      -- lock screen with mod+f12
      , ((modm,                 xK_F12  ), spawn "xscreensaver-command --lock")

      -- some programs to start with keybindings.
      , ((modm .|. shiftMask,   xK_f    ), spawn "iceweasel")
      , ((modm .|. shiftMask,   xK_m    ), spawn "icedove")

      -- prompts
      , ((modm,                 xK_s    ), scratchpadSpawnAction defaultConfig)
      , ((modm .|. shiftMask,   xK_s    ), sshPrompt currentXPConfig)
      , ((modm,                 xK_x    ), runOrRaisePrompt currentXPConfig)
      , ((modm .|. controlMask, xK_x    ), xmonadPrompt currentXPConfig)
      , ((modm .|. controlMask, xK_t    ), themePrompt currentXPConfig)

      -- window navigation keybindings.
      , ((modm,                 xK_Right), sendMessage $ Go R)
      , ((modm,                 xK_Left ), sendMessage $ Go L)
      , ((modm,                 xK_Up   ), sendMessage $ Go U)
      , ((modm,                 xK_Down ), sendMessage $ Go D)
      , ((modm .|. shiftMask,   xK_Right), sendMessage $ Swap R)
      , ((modm .|. shiftMask,   xK_Left ), sendMessage $ Swap L)
      , ((modm .|. shiftMask,   xK_Up   ), sendMessage $ Swap U)
      , ((modm .|. shiftMask,   xK_Down ), sendMessage $ Swap D)

      -- misc
      , ((modm,                 xK_Print), spawn "gnome-screenshot")
      , ((modm,                 xK_c    ), kill)
      , ((modm,                 xK_p    ), spawn "dmenu_run")

      , ((0,            0x1008ff2d), spawn "xlock")
      , ((0,            0x1008ff12), spawn "amixer sset 'Master' toggle")
      , ((0,            0x1008ff11), spawn "amixer sset 'Master' 5%-")
      , ((0,            0x1008ff13), spawn "amixer sset 'Master' 5%+")

      -- alarm -- ThinkVantage
      , ((0,            0x1008ff41), spawn "aplay /home/florian/Documents/sound/ilikeit.wav")
      , ((modm,         0x1008ff41), spawn "aplay /home/fpletz/Downloads/alarm/alarm1.wav")
      , ((controlMask,  0x1008ff41), spawn "aplay /home/fpletz/Downloads/alarm/alarm2.wav")
      , ((shiftMask,    0x1008ff41), spawn "aplay /home/fpletz/Downloads/alarm/alarm0.wav")

      -- display -- Fn + F7
      --, ((0,            0x1008ff59), spawn "ac fxd")
      --, ((shiftMask,    0x1008ff59), spawn "xrandr --output VGA1 --off")
      --, ((controlMask,  0x1008ff59), spawn "xrandr --output LVDS1 --off")
      ]

    myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
        -- set the window to floating mode and move by dragging
        [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))
        -- raise the window to the top of the stack
        , ((modMask, button2), (\w -> focus w >> windows W.shiftMaster))
        -- set the window to floating mode and resize by dragging
        , ((modMask, button3), (\w -> focus w >> Flex.mouseResizeWindow w))
        -- switch to previous workspace
        , ((modMask, button4), (\_ -> prevWS))
        -- switch to next workspace
        , ((modMask, button5), (\_ -> nextWS))
        ]

    -- find these out with 'xprop | grep CLASS'
    myManageHook :: ManageHook
    myManageHook = composeAll (
            [ className   =? "jetbrains-phpstorm"  --> doShift ws_code
            , className   =? "jetbrains-idea"      --> doShift ws_code
            , className   =? "Chromium-browser"    --> doShift ws_www
            , className   =? "Chromium"            --> doShift ws_www
            , className   =? "Gajim.py"            --> doShift ws_im
            , className   =? "Gajim"               --> doShift ws_im
            , className   =? "gajim"               --> doShift ws_im
            , className   =? "Pidgin"              --> doShift ws_im
            , className   =? "Skype"               --> doShift ws_im
            , className   =? "Quasselclient"       --> doShift ws_im
            , className   =? "Claws-mail"          --> doShift ws_mail
            , className   =? "Thunderbird"         --> doShift ws_mail
            , className   =? "Mail"                --> doShift ws_mail
            , className   =? "Icedove"             --> doShift ws_mail
            , className   =? "Keepassx"            --> doShift ws_mail
            , className   =? "Virt-Manager"        --> doShift ws_stuff
            , className   =? "mysql-workbench-bin" --> doShift ws_stuff
            , className   =? "Quodlibet"           --> doShift ws_music
            , className   =? "Rhythmbox"           --> doShift ws_music
            , className   =? "banshee"             --> doShift ws_music
            , className   =? "Totem"               --> doShift ws_music
            , className   =? "Vlc"                 --> doShift ws_music
            , className   =? "Iceweasel"           --> doShift ws_last
            , className   =? "Firefox"             --> doShift ws_last
            , className   =? "uzbl-core"           --> doShift ws_last
            , className   =? "uzbl-tabbed"         --> doShift ws_last
            , className   =? "Midori"              --> doShift ws_last
            , className   =? "Conkeror"            --> doShift ws_last
            , className   =? "luakit"              --> doShift ws_last
            , className   =? "Wpa_gui"             --> doShift ws_elev
            ]
            ++ [ className =? c --> doFloat | c <- myFloats ])
      where myFloats = [ "Volume"
                       , "XClock"
                       , "Network-admin"
                       , "frame"
                       , "MPlayer"
                       , "Pinentry-gtk-2"
                       , "Wicd-client.py"
                       ]

    myPP h = defaultPP { ppCurrent         = xmobarColor xm1 ""
                       , ppVisible         = xmobarColor xm2 ""
                       , ppHiddenNoWindows = \wsId ->
                                    if (reads wsId :: [(Int, String)]) == []
                                        then wsId
                                        else xmobarColor "#777" "" wsId
                       , ppSep             = xmobarColor "#666" "" "]["
                       , ppUrgent	       = xmobarColor "#fff" "" . \wsId -> wsId ++ "*"
                       , ppLayout          = xmobarColor "#15d" "" . (\x -> case x of
                                                "Full"                   -> " F "
                                                "DwmStyle Tall"          -> "DT "
                                                "DwmStyle Mirror Tall"   -> "DMT"
                                                "Tabbed Bottom Simplest" -> "TB "
                                                "ReflectX IM Grid"       -> "IM "
                                                "combining Tabbed Bottom Simplest and Full with TwoPane using Not (Role \"gimp-toolbox\")"           -> " G "
                                                "ReflectX combining Grid and Grid with TwoPane using Or (Role \"MainWindow\") (Or (Role \"buddy_list\") (Role \"roster\"))" -> "IM "
                                                _                        -> x)
                       , ppWsSep           = xmobarColor "#666" "" "|"
                       , ppTitle           = shorten xmobarTitleLength . (\s -> s ++ " ")
                       --, ppOrder           = reverse
                       , ppOutput          = hPutStrLn h
                       }

    myLayouts = avoidStruts $ smartBorders
              $ onWorkspaces [ws_shell, ws_code, ws_www, ws_mail, ws_elev] (tabbedLayout ||| (dwmLayout $ tiled ||| Mirror tiled))
              -- $ onWorkspaces [ws_code, ws_www] (tabbedLayout ||| tiled)
              $ onWorkspaces [ws_im] imLayout2
              $ (dwmLayout $ tiled ||| Mirror tiled) ||| tabbedLayout ||| Full ||| gimpLayout
            where
                tiled   = Tall nmaster delta ratio
                nmaster = 1
                delta   = 3/100
                ratio   = 1/2

                dwmLayout    = dwmStyle shrinkText currentTheme
                tabbedLayout = tabbedBottomAlways shrinkText currentTheme
                gimpLayout   = combineTwoP (TwoPane 0.04 0.82) (tabbedLayout) (Full) (Not (Role "gimp-toolbox"))
                imLayout1    = (reflectHoriz (withIM (1%8) (Role "buddy_list") Grid))
                imLayout2    = reflectHoriz $ combineTwoP (TwoPane delta (1%8)) (Grid) (Grid) (Or (Role "MainWindow") (Or (Role "buddy_list") (Role "roster")))
                imLayout3    = reflectHoriz $ combineTwoP (TwoPane delta (1/8)) (Grid) (Mirror tiled) (Or (Role "MainWindow") (Or (Role "buddy_list") (Role "roster")))


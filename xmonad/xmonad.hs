{-# LANGUAGE ImplicitParams, NoMonomorphismRestriction #-}
import XMonad hiding ( (|||) ) -- hide the ||| because it is overwriten by LayoutCombinators
import Data.Monoid
import Control.Monad
import System.Exit
import System.Cmd (system)
import Data.List

import XMonad.Util.Run
import XMonad.Util.WorkspaceCompare
import XMonad.Util.SpawnOnce

import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
--import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.Reflect
import XMonad.Layout.Spacing
import XMonad.Layout.Monitor
-- import XMonad.Layout.BalancedTile
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import XMonad.Layout.LayoutCombinators

-- import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.Script
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers
-- import XMonad.Hooks.InsertPosition

import Graphics.X11.ExtraTypes.XF86
import XMonad.Actions.UpdatePointer
import XMonad.Actions.GridSelect
import XMonad.Actions.CopyWindow
import XMonad.Actions.Navigation2D

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
 
-- imports for grid colorizer
import Data.Word (Word8)
import Text.Printf


-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "BASHMUXTERM='yes' urxvt"
 
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myBorderWidth   = 0
 
myModMask       = mod4Mask
 
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9", "0", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"]
 
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#63a5b3"

myFont = "xft:Clean:style=bold:size=9:antialias=true"

menuCmd = "dmenu_run -fn '" ++ myFont ++ "' -nb 'black' -nf 'gray' -sb '#63a5b3' -sf 'white'"

gsconfig colorizer = (buildDefaultGSConfig colorizer) { gs_cellheight = 75, gs_cellwidth = 150, gs_font = "xft:Monospace:size=10"}

myGridColorizer = colorRangeFromClassName
                      (0x0,0x10,0x10) -- lowest inactive bg
                      (0x93,0xE0,0xE3) -- highest inactive bg
                      black            -- active bg
                      white            -- inactive fg
                      white            -- active fg
   where black = minBound
         white = maxBound

myGSConfig = gsconfig myGridColorizer


-- copied out of grid select
hsv2rgb :: Fractional a => (Integer,a,a) -> (a,a,a)
hsv2rgb (h,s,v) =
    let hi = (div h 60) `mod` 6 :: Integer
        f = (((fromInteger h)/60) - (fromInteger hi)) :: Fractional a => a
        q = v * (1-f)
        p = v * (1-s)
        t = v * (1-(1-f)*s)
    in case hi of
         0 -> (v,t,p)
         1 -> (q,v,p)
         2 -> (p,v,t)
         3 -> (p,q,v)
         4 -> (t,p,v)
         5 -> (v,p,q)
         _ -> error "The world is ending. x mod a >= a."

twodigitHex :: Word8 -> String
twodigitHex a = printf "%02x" a

myGridSpawnColorizer :: String -> Bool -> X (String, String)
myGridSpawnColorizer s active =
    let seed x = toInteger (sum $ map ((*x).fromEnum) s) :: Integer
        (r,g,b) = hsv2rgb (180,
                           45/100,
                           (fromInteger ((seed 121) `mod` 1000))/5000+0.1)
    in if active
         then return ("#001010", "white")
         else return ("#" ++ concat (map (twodigitHex.(round :: Double -> Word8).(*256)) [r, g, b] ), "white")

myGSSpawnConfig = gsconfig myGridSpawnColorizer

myGridSpawnList = ["audacious", "alienarena", "dolphin",  "emacs", "firefox",  "gimp", "gwenview", "k3b", "kate", "kcalc", "okular", "oocalc", "oowriter", "vlc", "VirtualBox", "urxvt"]
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
 
    -- launch dmenu
    , ((modm,               xK_p     ), spawn (menuCmd ++ " 2>&1 >/dev/null"))
 
    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")
 
    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm, xK_Escape     ), kill)
 
     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
 
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    
    , ((modm,               xK_a ), sendMessage $ JumpToLayout "Tall")
    , ((modm,               xK_s ), sendMessage $ JumpToLayout "3 Tall")
    , ((modm,               xK_d ), sendMessage $ JumpToLayout "Wide")
    , ((modm,               xK_f ), sendMessage $ JumpToLayout "Full")
    , ((modm .|. shiftMask, xK_f ), sendMessage $ JumpToLayout "Max")
 
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
 
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
    , ((mod1Mask,           xK_Tab   ), windows W.focusDown)
 
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
 
    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    , ((modm,               xK_u     ), focusUrgent  )
 
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
 
    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
 
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
 
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
 
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
 
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
--    , ((modm .|. shiftMask  ,xK_b), sendMessage $ SetStruts [minBound .. maxBound] [])
    , ((modm              , xK_b     ), sendMessage ToggleStruts)
 
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), spawn "echo 'done' >~/tmp/exitsession" >> io (exitHook >> exitWith ExitSuccess))

    -- Restart xmonad
--    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    -- Hack up a restart because my state info is too large for the command line so xmonad's built in restart fails
    , ((modm              , xK_q     ), spawn "xmonad --recompile && ((sleep 3;xmonad) & killall -u $USER xmonad-x86_64-linux)")
--    , ((modm              , xK_q     ), spawn "xmonad --recompile;" >> restart "xmonad-x86_64-linux" False)

    -- Restart my dzen status bar.
    , ((modm              , xK_r     ), spawn "xmonad --recompile;" >> io exitHook)
    , ((modm .|. shiftMask, xK_r     ), spawn "killall conky; killall dzconky.sh; killall dzen2; xmonad --recompile; ~/.xmonad/dzconky.sh")

    -- screen lock and suspends
    , ((modm .|. shiftMask, xK_l ), spawn "xscreensaver-command -lock || xautolock -locknow")
    , ((mod1Mask .|. controlMask, xK_l ), spawn "xscreensaver-command -lock || xautolock -locknow")
    , ((modm .|. shiftMask, xK_s ), spawn "(xscreensaver-command -lock || xautolock -locknow); sudo /usr/sbin/pm-suspend")
    , ((modm              , xK_c     ), spawn "kcalc")
    -- Volume Up
    , ((0, xF86XK_AudioRaiseVolume      ), spawn "amixer sset Master 1%+;amixer sset 'Master Front' 1%+")
    -- Volume Down
    , ((0, xF86XK_AudioLowerVolume      ), spawn "amixer sset Master 1%-;amixer sset 'Master Front' 1%-")
    -- Mute On/Off
    , ((0, xF86XK_AudioMute                     ), spawn "amixer sset Master toggle")
    -- control opacity
    , ((modm, xK_o                              ), spawn "transset -p 1")
    , ((modm .|. shiftMask, xK_o                ), spawn "transset -p .7")
    -- grid select menus
    , ((modm .|. shiftMask, xK_Tab              ), goToSelected myGSConfig)
    , ((modm, xK_grave                          ), spawnSelected myGSSpawnConfig myGridSpawnList)

    -- Directional navigation of windows
    , ((modm,                 xK_Right), windowGo R False)
    , ((modm,                 xK_Left ), windowGo L False)
    , ((modm,                 xK_Up   ), windowGo U False)
    , ((modm,                 xK_Down ), windowGo D False)

    -- Swap adjacent windows
    , ((modm .|. shiftMask, xK_Right), windowSwap R False)
    , ((modm .|. shiftMask, xK_Left ), windowSwap L False)
    , ((modm .|. shiftMask, xK_Up   ), windowSwap U False)
    , ((modm .|. shiftMask, xK_Down ), windowSwap D False)

 -- Send window to adjacent screen
    , ((modm .|. controlMask,    xK_Right    ), windowToScreen R False)
    , ((modm .|. controlMask,    xK_Left     ), windowToScreen L False)
    , ((modm .|. controlMask,    xK_Up       ), windowToScreen U False)
    , ((modm .|. controlMask,    xK_Down     ), windowToScreen D False)

-- Swap workspaces on adjacent screens
    , ((modm .|. mod1Mask, xK_Right    ), screenSwap R False)
    , ((modm .|. mod1Mask, xK_Left    ), screenSwap L False)
    , ((modm .|. mod1Mask, xK_Up    ), screenSwap U False)
    , ((modm .|. mod1Mask, xK_Down    ), screenSwap D False)

    ]
    ++
 
    --
    -- mod-[1..9], Switch to workspace N
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9]++[xK_0]++[xK_F1 .. xK_F12])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
 
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
 
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
 
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
 
    , ((modm, button4), (\w -> focus w >> sendMessage Expand))
    , ((modm, button5), (\w -> focus w >> sendMessage Shrink))
    , ((modm .|. shiftMask, button4), (\w -> focus w >> sendMessage MirrorExpand))
    , ((modm .|. shiftMask, button5), (\w -> focus w >> sendMessage MirrorShrink))
    ]
 
------------------------------------------------------------------------
-- Layouts:
 
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
defaultLayout = avoidStruts $ renamed [CutWordsLeft 4] $ leftside $ reflectHoriz $ rightside $ reflectHoriz $ (tiled ||| tiled3 ||| mir ||| maxim) ||| noBorders  Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = renamed [Replace "Tall"] $ spacing 6 $ ResizableTall nmaster delta ratio []
    tiled3  = renamed [Replace "3 Tall"] $ spacing 6 $ ThreeCol nmaster delta ratio3
    mir = renamed [Replace "Wide"] $ Mirror tiled 
    maxim = renamed [Replace "Max"] $ Full
 
    -- The default number of windows in the master pane
    nmaster = 1
 
    -- Default proportion of screen occupied by master pane
    ratio   = 6/10
    ratio3  = 4/10
 
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

    leftside = withIM (1/10) leftmatch
    leftmatch = (Title "Speedbar 1.0")

    rightside = withIM (1/10) rightmatch
    rightmatch = Or (Resource "xclock") $ Or (Role "buddy_list") $ (Title "blablabla")

gimpLayout     = avoidStruts
                    (withIM (1/10) (Role "gimp-toolbox")
                  $ reflectHoriz
                  $ withIM (1/6) (Role "gimp-dock") Full)

myLayout = onWorkspace "7" gimpLayout $ defaultLayout

------------------------------------------------------------------------
-- Window rules:
 
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--

-- avoidMaster:  Avoid the master window, but otherwise manage new windows normally
avoidMaster :: W.StackSet i l a s sd -> W.StackSet i l a s sd
avoidMaster = W.modify' $ \c -> case c of
    W.Stack t [] (r:rs) -> W.Stack t [r] rs
    otherwise -> c
 
myManageHook = composeAll . concat $
--    [ [isDialog --> doFloat]
    [ [className =? c --> doCenterFloat | c <- myCFloats]
    , [title =? t --> doCenterFloat | t <- myTFloats]
    , [resource =? r --> doCenterFloat | r <- myRFloats]
    , [resource =? i --> doIgnore | i <- myIgnores]
    , [role       =? x --> ask >>= doF . W.sink | x <- myRlNoFloats]
    , [(className =? x <||> title =? x <||> resource =? x) --> ask >>= doF . W.sink | x <- myNoFloats]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "1" | x <- my1Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "2" | x <- my2Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "3" | x <- my3Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "4" | x <- my4Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "5" | x <- my5Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "6" | x <- my6Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "7" | x <- my7Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "8" | x <- my8Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShift "9" | x <- my9Shifts]
--    , [(className =? "Firefox" <&&> resource =? "Dialog") --> doFloat]
--    , [(className =? x <||> title =? x <||> resource =? x) --> doTransparent 0xaa000000 | x <- myTrans]
    , [doTransparent 0xb2000000]
    , [(className =? x <||> title =? x <||> resource =? x) --> doTransparent 0xFF000000 | x <- myOpaque]
    , [(className =? "Firefox" <&&> (role =? "Preferences" <||> role =? "Manager")) --> doTransparent 0xFF000000]
    , [isDialog --> doTransparent 0xFF000000]
    , [(className =? x <||> title =? x <||> resource =? x) --> doAvoidMaster | x <- myAvoidMasters]
    , [fmap ("Joint BUS (JBUS)" `isPrefixOf`) title --> doShift "4"]
    , [fmap ("Joint BUS (JBUS)" `isPrefixOf`) title --> doTransparent 0xFF000000]
--    , isFullscreen              --> (doF W.focusDown <+> doFullFloat) -- fix flash fullscreen
--     , [className =? c --> doF focusDown | c <- noStealFocusWins]
--    , [resource =? "xclock" --> doTransparent 0.8]
--    , [resource =? "konsole" --> (ask >>= \w -> liftX (focus w >> windows W.shiftMaster) >> idHook)]
--    , [(className =? "dzen" <||> title =? "dzen" <||> resource =? "dzen") --> doTransparent 0xb2000000]
    , [(className =? x <||> title =? x <||> resource =? x) --> doCopyAll | x <- myCopyAlls]
    , [manageDocks]
    ]
    where
    role       = stringProperty "WM_WINDOW_ROLE"
    doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    doAvoidMaster = doF avoidMaster
--    doTransparent t = doX (\w -> spawn $ unwords ["transset", "-i", show w, show t])
    doTransparent t = (ask >>= \w -> liftX (setOpacity w t) >> idHook)
--    doCopy1 = (ask >>= doF . \w -> (copyWindow w "1"))
    doCopyAll = doF copyToAll
    myCFloats = ["MPlayer", "Nvidia-settings", "XCalc", "XFontSel", "Xmessage"]
    myTFloats = ["Downloads", "Firefox Preferences", "Save As..."] --"Buddy List"
    myRFloats = ["kcalc"]
    myIgnores = ["desktop_window", "kdesktop", "cairo-dock"]
    myRlNoFloats = ["gimp-image-window", "gimp-dock", "gimp-toolbox"]
    myNoFloats = ["dreamchess", "pouetChess"]
    my1Shifts = []
    my2Shifts = []
    my3Shifts = []
    my4Shifts = []
    my5Shifts = ["JSAF"]
    my6Shifts = ["Tci"]
    my7Shifts = ["Gimp"]
    my8Shifts = []
    my9Shifts = ["VirtualBox", "Wine"]
    myAvoidMasters = ["konsole", "xchat", "urxvt", "screen", "Speedbar 1.0", "Ediff"]
    myCopyAlls = ["gcompris", "xclock"]
--    myTrans = ["xclock", "Firefox", "Kate", "Okular", "Google-chrome"]
    myOpaque = ["Audacious", "kcalc", "vlc", "mplayer", "Plugin-container", "URxvt", "screen", "konsole", "VirtualBox", "Xmessage", "gcompris", "gimp", "JSAF", "Tci", "xv", "Gwenview", "Vncviewer"]

clock = monitor {
  -- Cairo-clock creates 2 windows with the same classname, thus also using title
  prop = ClassName "dzen title"
  -- rectangle 150x150 in lower right corner, assuming 1280x800 resolution
  , rect = Rectangle (0) (0) 1920 16
  -- avoid flickering
  , persistent = True
  -- make the window transparent
  , opacity = 0.6
  -- hide on start
  , visible = True
  -- assign it a name to be able to toggle it independently of others
  , name = "clock"
}
    
------------------------------------------------------------------------
-- Event handling
 
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- myEventHook = mempty
myEventHook = docksEventHook

------------------------------------------------------------------------
-- Status bars and logging

--myLogHook = dynamicLogXinerama
myLogHook = dynamicLogWithPP defaultPP { ppOutput  = hPutStrLn ?hlogpipe
--                                         , ppSort  = getSortByXineramaRule
                                         , ppCurrent  = dzenColor "cyan" "black"
                                         , ppVisible  = dzenColor "#63a5b3" "black"
                                         , ppUrgent   = dzenColor "black" "cyan"
                                         , ppSort  = getSortByIndex
                                         , ppTitle = (\str -> "")}
                               >> updatePointer (Relative 0.5 0.5)
-- myLogHook = dynamicLog >> execScriptHook "logscript"
 
------------------------------------------------------------------------
-- Startup hook
 
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
myStartupHook = return ()
-- startup

startup :: X ()
startup = do
  spawnOnce "nitrogen --restore"
  spawn "xsetroot -cursor_name left_ptr"
  spawnOnce "xcompmgr -n"
  spawnOnce "xscreensaver -no-splash"
  spawnOnce "~/.xmonad/dzconky.sh"

exitHook :: IO ()
exitHook = do
    -- Make sure the panels gets reloaded with xmonad.
    spawn "killall dzen2"
    return ()




myUrgencyHook = withUrgencyHookC uH uC
  where
    uH = dzenUrgencyHook { args = ["-bg", "cyan", "-fg", "black", "-xs", "1", "-fn", myFont] }
    uC = urgencyConfig {
                         suppressWhen = Focused,
                         remindWhen = Every 10
                       }

--data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

--instance UrgencyHook LibNotifyUrgencyHook where
--  urgencyHook LibNotifyUrgencyHook w = do
--    name <- getName w
--    ws <- gets windowset
--    whenJust (W.findTag w ws) (flash name)
--  where flash name index =
--    safeSpawn "notify-send" (show name ++ " requests your attention on workspace " ++ index)
    
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
 
-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  hlogpipe <- spawnPipe "cat >~/.xmonad/dynlogpipe"; let ?hlogpipe = hlogpipe
  xmonad $ ewmh $ myUrgencyHook $ withNavigation2DConfig defaultNavigation2DConfig {defaultTiledNavigation = centerNavigation } $ defaults
 
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
 
      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
 
      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
--                                       <+> manageMonitor clock,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

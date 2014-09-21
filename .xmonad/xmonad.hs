import XMonad
import Data.Monoid

import qualified XMonad.StackSet as W
import qualified Data.Map as M

myTerm = "xfce4-terminal"
myLauncher = "gmrun"

myWorkspaces = map show [1..9]

myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
  [ ((modm .|. shiftMask, xK_space), spawn myTerm)
  , ((modm, xK_Return), spawn myLauncher)
  , ((modm .|. shiftMask, xK_x), kill)
  , ((modm, xK_Tab), windows W.focusDown)
  , ((modm .|. shiftMask, xK_Tab), windows W.focusUp)
  , ((modm, xK_a), sendMessage NextLayout)
  ] ++
  [((m .|. modm, k), windows $ f i)
  | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
  , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++
  [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
  | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
  , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

main = xmonad defaultConfig
    { terminal = "xfce4-term"
    , modMask = mod1Mask
    , borderWidth = 1
    , focusFollowsMouse = False
    , focusedBorderColor = "#d3d3d3"
    , keys = myKeys
    }

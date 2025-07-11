---@diagnostic disable: missing-return
---@meta RarityBarContainer

---World of Warcraft addon library for creating and managing progress bars and bar groups
---@class RarityBarContainer
---@field LEFT_TO_RIGHT integer # Orientation constant: 1
---@field BOTTOM_TO_TOP integer # Orientation constant: 2
---@field RIGHT_TO_LEFT integer # Orientation constant: 3
---@field TOP_TO_BOTTOM integer # Orientation constant: 4
local RarityBarContainer = {}

---Orientation constants for bar layout
---@enum RarityBarContainer.Orientation
RarityBarContainer.Orientation = {
	LEFT_TO_RIGHT = 1,
	BOTTOM_TO_TOP = 2,
	RIGHT_TO_LEFT = 3,
	TOP_TO_BOTTOM = 4,
}

---@class RarityBarContainer.CallbackObject
---@field RegisterCallback fun(self: RarityBarContainer.CallbackObject, event: string, method: function|string, target?: any)
---@field UnregisterCallback fun(self: RarityBarContainer.CallbackObject, event: string, target?: any)
---@field Fire fun(self: RarityBarContainer.CallbackObject, event: string, ...)

---Individual progress bar
---@class RarityBarContainer.Bar : Frame
---@field callbacks RarityBarContainer.CallbackObject # Callback handler for bar events
---@field name string # Unique name of the bar
---@field value number # Current value of the bar
---@field maxValue number # Maximum value of the bar
---@field isTimer boolean # Whether this bar is a timer
---@field isTimerRunning boolean # Whether timer is currently running
---@field isAnimating boolean # Whether bar is currently animating
---@field ownerGroup RarityBarContainer.BarGroup? # Parent bar group
---@field orientation RarityBarContainer.Orientation # Bar orientation
---@field length number # Length dimension of the bar
---@field thickness number # Thickness dimension of the bar
---@field fill boolean # Whether timer fills up or empties
---@field flashing boolean # Whether bar is currently flashing
---@field fading boolean # Whether bar is currently fading
---@field showIcon boolean # Whether icon is shown
---@field showLabel boolean # Whether text label is shown
---@field showTimerLabel boolean # Whether timer label is shown
local RarityBarContainerBar = {}

---Group of progress bars with shared layout and properties
---@class RarityBarContainer.BarGroup : Frame
---@field callbacks RarityBarContainer.CallbackObject # Callback handler for group events
---@field name string # Unique name of the bar group
---@field orientation RarityBarContainer.Orientation # Layout orientation
---@field length number # Length dimension
---@field thickness number # Thickness dimension
---@field locked boolean # Whether group is locked from moving
---@field growup boolean # Whether bars grow in reverse direction
---@field spacing number # Spacing between bars
---@field maxBars number? # Maximum number of bars to display
---@field texture string # Default texture for bars
---@field showIcon boolean # Whether icons are shown by default
---@field showLabel boolean # Whether labels are shown by default
---@field showTimerLabel boolean # Whether timer labels are shown by default
local RarityBarContainerBarGroup = {}

-- ============================================================================
-- MAIN LIBRARY METHODS
-- ============================================================================

---Embed RarityBarContainer functionality into a target object
---@param target table The object to embed into
---@return table target The target object with embedded methods
function RarityBarContainer:Embed(target) end

---Get a bar by name
---@param name string The name of the bar
---@return RarityBarContainer.Bar? bar The bar object, or nil if not found
function RarityBarContainer:GetBar(name) end

---Get all bars owned by this object
---@return table<string, RarityBarContainer.Bar>? bars Table of all bars, or nil if none
function RarityBarContainer:GetBars() end

---Check if this object has any bars
---@return boolean hasAny True if any bars exist
function RarityBarContainer:HasAnyBar() end

---Iterate over all bars owned by this object
---@return fun(): string?, RarityBarContainer.Bar? iterator Iterator function
function RarityBarContainer:IterateBars() end

---Create a new bar from a prototype
---@param prototype table The bar prototype to use
---@param name string Unique name for the bar
---@param text? string Display text
---@param value? number Initial value
---@param maxVal? number Maximum value
---@param icon? string|number Icon texture
---@param orientation? RarityBarContainer.Orientation Bar orientation
---@param length? number Bar length
---@param thickness? number Bar thickness
---@param isTimer? boolean Whether this is a timer bar
---@return RarityBarContainer.Bar bar The created bar
---@return boolean isNew Whether this is a newly created bar
function RarityBarContainer:NewBarFromPrototype(
	prototype,
	name,
	text,
	value,
	maxVal,
	icon,
	orientation,
	length,
	thickness,
	isTimer
)
end

---Create a new counter bar
---@param name string Unique name for the bar
---@param text? string Display text
---@param value? number Initial value
---@param maxVal? number Maximum value
---@param icon? string|number Icon texture
---@param orientation? RarityBarContainer.Orientation Bar orientation
---@param length? number Bar length
---@param thickness? number Bar thickness
---@param isTimer? boolean Whether this is a timer bar
---@return RarityBarContainer.Bar bar The created bar
---@return boolean isNew Whether this is a newly created bar
function RarityBarContainer:NewCounterBar(name, text, value, maxVal, icon, orientation, length, thickness, isTimer) end

---Create a new timer bar
---@param name string Unique name for the bar
---@param text? string Display text
---@param time? number Initial time remaining
---@param maxTime? number Maximum time
---@param icon? string|number Icon texture
---@param orientation? RarityBarContainer.Orientation Bar orientation
---@param length? number Bar length
---@param thickness? number Bar thickness
---@return RarityBarContainer.Bar bar The created bar
---@return boolean isNew Whether this is a newly created bar
function RarityBarContainer:NewTimerBar(name, text, time, maxTime, icon, orientation, length, thickness) end

---Release a bar back to the recycling pool
---@param name string|RarityBarContainer.Bar The bar name or bar object to release
function RarityBarContainer:ReleaseBar(name) end

---Create a new bar group
---@param name string Unique name for the group
---@param orientation? RarityBarContainer.Orientation Layout orientation
---@param length? number Group length
---@param thickness? number Group thickness
---@param frameName? string Optional frame name
---@return RarityBarContainer.BarGroup group The created bar group
function RarityBarContainer:NewBarGroup(name, orientation, length, thickness, frameName) end

---Get a bar group by name
---@param name string The name of the bar group
---@return RarityBarContainer.BarGroup? group The bar group, or nil if not found
function RarityBarContainer:GetBarGroup(name) end

---Get all bar groups owned by this object
---@return table<string, RarityBarContainer.BarGroup>? groups Table of all bar groups, or nil if none
function RarityBarContainer:GetBarGroups() end

---Create a new bar prototype for custom bar types
---@param super? table Super prototype to inherit from
---@return table prototype New bar prototype
function RarityBarContainer.NewBarPrototype(super) end

-- ============================================================================
-- BAR METHODS
-- ============================================================================

---Create/initialize the bar with given parameters
---@param text? string Display text
---@param value? number Initial value
---@param maxVal? number Maximum value
---@param icon? string|number Icon texture
---@param orientation? RarityBarContainer.Orientation Bar orientation
---@param length? number Bar length
---@param thickness? number Bar thickness
---@param isTimer? boolean Whether this is a timer bar
function RarityBarContainerBar:Create(text, value, maxVal, icon, orientation, length, thickness, isTimer) end

---Get the bar group that owns this bar
---@return RarityBarContainer.BarGroup? group The owning group, or nil
function RarityBarContainerBar:GetGroup() end

---Set the bar's font
---@param font? string Font path
---@param size? number Font size
---@param flags? string Font flags
function RarityBarContainerBar:SetFont(font, size, flags) end

---Set the bar's icon
---@param icon? string|number Icon texture path or ID
function RarityBarContainerBar:SetIcon(icon) end

---Show the bar's icon
function RarityBarContainerBar:ShowIcon() end

---Hide the bar's icon
function RarityBarContainerBar:HideIcon() end

---Check if icon is shown
---@return boolean shown True if icon is visible
function RarityBarContainerBar:IsIconShown() end

---Set the bar's text label
---@param text string Label text
function RarityBarContainerBar:SetLabel(text) end

---Get the bar's text label
---@return string text Current label text
function RarityBarContainerBar:GetLabel() end

---Set the bar's text label (API compatibility alias)
---@param text string Label text
function RarityBarContainerBar:SetText(text) end

---Get the bar's text label (API compatibility alias)
---@return string text Current label text
function RarityBarContainerBar:GetText() end

---Show the text label
function RarityBarContainerBar:ShowLabel() end

---Hide the text label
function RarityBarContainerBar:HideLabel() end

---Check if label is shown
---@return boolean shown True if label is visible
function RarityBarContainerBar:IsLabelShown() end

---Set the timer label text
---@param text string Timer label text
function RarityBarContainerBar:SetTimerLabel(text) end

---Get the timer label text
---@return string text Current timer label text
function RarityBarContainerBar:GetTimerLabel() end

---Show the timer label
function RarityBarContainerBar:ShowTimerLabel() end

---Hide the timer label
function RarityBarContainerBar:HideTimerLabel() end

---Check if timer label is shown
---@return boolean shown True if timer label is visible
function RarityBarContainerBar:IsValueLabelShown() end

---Set the bar's texture
---@param texture string Texture path
function RarityBarContainerBar:SetTexture(texture) end

---Set the background color
---@param r number Red component (0-1)
---@param g number Green component (0-1)
---@param b number Blue component (0-1)
---@param a? number Alpha component (0-1), defaults to 0.6
function RarityBarContainerBar:SetBackgroundColor(r, g, b, a) end

---Set color at specific value point for gradient
---@param at number Value point (0-1)
---@param r number Red component (0-1)
---@param g number Green component (0-1)
---@param b number Blue component (0-1)
---@param a number Alpha component (0-1)
function RarityBarContainerBar:SetColorAt(at, r, g, b, a) end

---Remove color at specific value point
---@param at number Value point to remove
function RarityBarContainerBar:UnsetColorAt(at) end

---Remove all custom colors
function RarityBarContainerBar:UnsetAllColors() end

---Get the bar's length
---@return number length Current length
function RarityBarContainerBar:GetLength() end

---Set the bar's length
---@param length number New length
function RarityBarContainerBar:SetLength(length) end

---Get the bar's thickness
---@return number thickness Current thickness
function RarityBarContainerBar:GetThickness() end

---Set the bar's thickness
---@param thickness number New thickness
function RarityBarContainerBar:SetThickness(thickness) end

---Set the bar's orientation
---@param orientation RarityBarContainer.Orientation New orientation
function RarityBarContainerBar:SetOrientation(orientation) end

---Get the bar's orientation
---@return RarityBarContainer.Orientation orientation Current orientation
function RarityBarContainerBar:GetOrientation() end

---Check if bar is vertical
---@return boolean vertical True if vertical orientation
function RarityBarContainerBar:IsVertical() end

---Set the bar's current value
---@param val number New value
---@param maxValue? number New maximum value
function RarityBarContainerBar:SetValue(val, maxValue) end

---Set the display maximum (for clamping display)
---@param val number Maximum value to display
function RarityBarContainerBar:SetDisplayMax(val) end

---Set the bar's maximum value
---@param val number New maximum value
function RarityBarContainerBar:SetMaxValue(val) end

---Register a time-based trigger for timer bars
---@param time number Time threshold to trigger at
---@param func function Function to call when triggered
function RarityBarContainerBar:RegisterTimeLeftTrigger(time, func) end

---Set timer values and start the timer
---@param remaining number Time remaining
---@param maxVal? number Maximum time value
function RarityBarContainerBar:SetTimer(remaining, maxVal) end

---Stop the timer
function RarityBarContainerBar:StopTimer() end

---Set fill mode (whether timer fills up or empties)
---@param fill boolean True to fill up, false to empty
function RarityBarContainerBar:SetFill(fill) end

---Update the bar's color based on current value
function RarityBarContainerBar:UpdateColor() end

---Animate the bar to new position and scale
---@param x number Target X position
---@param y number Target Y position
---@param scale number Target scale
---@param time number Animation duration
function RarityBarContainerBar:AnimateTo(x, y, scale, time) end

---Animate moving this bar to another group
---@param group RarityBarContainer.BarGroup Target group
function RarityBarContainerBar:AnimateToGroup(group) end

---Start fading the bar out
---@param time? number Fade duration (default 0.5)
function RarityBarContainerBar:Fade(time) end

---Stop fading
function RarityBarContainerBar:StopFade() end

---Check if bar is currently fading
---@return boolean fading True if fading
function RarityBarContainerBar:IsFading() end

---Start flashing the bar
---@param period? number Flash period (default 1.0)
---@param times? number Number of times to flash (nil for infinite)
function RarityBarContainerBar:Flash(period, times) end

---Stop flashing
function RarityBarContainerBar:StopFlash() end

---Add an OnUpdate function
---@param func function Function to call on each update
function RarityBarContainerBar:AddOnUpdate(func) end

---Remove an OnUpdate function
---@param func function Function to remove
function RarityBarContainerBar:RemoveOnUpdate(func) end

---Set width (maps to length or thickness based on orientation)
---@param width number New width
function RarityBarContainerBar:SetWidth(width) end

---Set height (maps to length or thickness based on orientation)
---@param height number New height
function RarityBarContainerBar:SetHeight(height) end

-- ============================================================================
-- BAR GROUP METHODS
-- ============================================================================

---Create a new bar from prototype in this group
---@param prototype table Bar prototype to use
---@param name string Unique bar name
---@param ... any Additional arguments passed to bar creation
---@return RarityBarContainer.Bar bar The created bar
---@return boolean isNew Whether this is a newly created bar
function RarityBarContainerBarGroup:NewBarFromPrototype(prototype, name, ...) end

---Create a new counter bar in this group
---@param name string Unique bar name
---@param text? string Display text
---@param value? number Initial value
---@param maxVal? number Maximum value
---@param icon? string|number Icon texture
---@param isTimer? boolean Whether this is a timer bar
---@return RarityBarContainer.Bar bar The created bar
---@return boolean isNew Whether this is a newly created bar
function RarityBarContainerBarGroup:NewCounterBar(name, text, value, maxVal, icon, isTimer) end

---Create a new timer bar in this group
---@param name string Unique bar name
---@param text? string Display text
---@param time? number Initial time remaining
---@param maxTime? number Maximum time
---@param icon? string|number Icon texture
---@param flashTrigger? number Time to start flashing (default 5)
---@return RarityBarContainer.Bar bar The created bar
---@return boolean isNew Whether this is a newly created bar
function RarityBarContainerBarGroup:NewTimerBar(name, text, time, maxTime, icon, flashTrigger) end

---Lock the group from being moved
function RarityBarContainerBarGroup:Lock() end

---Unlock the group to allow moving
function RarityBarContainerBarGroup:Unlock() end

---Check if group is locked
---@return boolean locked True if locked
function RarityBarContainerBarGroup:IsLocked() end

---Set maximum number of bars to display
---@param num? number Maximum bars (nil for unlimited)
function RarityBarContainerBarGroup:SetMaxBars(num) end

---Get maximum number of bars to display
---@return number? maxBars Maximum bars, or nil if unlimited
function RarityBarContainerBarGroup:GetMaxBars() end

---Set time threshold for flashing timer bars
---@param time number Flash trigger time
function RarityBarContainerBarGroup:SetFlashTrigger(time) end

---Set flash period for timer bars
---@param period number Flash period in seconds
function RarityBarContainerBarGroup:SetFlashPeriod(period) end

---Set default texture for all bars in group
---@param texture string Texture path
function RarityBarContainerBarGroup:SetTexture(texture) end

---Set font for all bars in group
---@param font string Font path
---@param size number Font size
---@param flags string Font flags
function RarityBarContainerBarGroup:SetFont(font, size, flags) end

---Set fill mode for timer bars in group
---@param fill boolean True to fill up, false to empty
function RarityBarContainerBarGroup:SetFill(fill) end

---Check if group is in fill mode
---@return boolean filling True if filling
function RarityBarContainerBarGroup:IsFilling() end

---Show icons for all bars in group
function RarityBarContainerBarGroup:ShowIcon() end

---Hide icons for all bars in group
function RarityBarContainerBarGroup:HideIcon() end

---Check if icons are shown
---@return boolean shown True if icons are visible
function RarityBarContainerBarGroup:IsIconShown() end

---Show labels for all bars in group
function RarityBarContainerBarGroup:ShowLabel() end

---Hide labels for all bars in group
function RarityBarContainerBarGroup:HideLabel() end

---Check if labels are shown
---@return boolean shown True if labels are visible
function RarityBarContainerBarGroup:IsLabelShown() end

---Show timer labels for all bars in group
function RarityBarContainerBarGroup:ShowTimerLabel() end

---Hide timer labels for all bars in group
function RarityBarContainerBarGroup:HideTimerLabel() end

---Check if timer labels are shown
---@return boolean shown True if timer labels are visible
function RarityBarContainerBarGroup:IsValueLabelShown() end

---Set spacing between bars
---@param spacing number Spacing in pixels
function RarityBarContainerBarGroup:SetSpacing(spacing) end

---Get spacing between bars
---@return number spacing Current spacing
function RarityBarContainerBarGroup:GetSpacing() end

---Get a bar by name from this group
---@param name string Bar name
---@return RarityBarContainer.Bar? bar The bar, or nil if not found
function RarityBarContainerBarGroup:GetBar(name) end

---Get all bars in this group
---@return table<string, RarityBarContainer.Bar>? bars All bars in group
function RarityBarContainerBarGroup:GetBars() end

---Check if group has any bars
---@return boolean hasAny True if any bars exist
function RarityBarContainerBarGroup:HasAnyBar() end

---Iterate over bars in this group
---@return fun(): string?, RarityBarContainer.Bar? iterator Iterator function
function RarityBarContainerBarGroup:IterateBars() end

---Move a bar to another group
---@param bar string|RarityBarContainer.Bar Bar name or object
---@param group RarityBarContainer.BarGroup Target group
function RarityBarContainerBarGroup:MoveBarToGroup(bar, group) end

---Remove a bar from this group
---@param bar string|RarityBarContainer.Bar Bar name or object
function RarityBarContainerBarGroup:RemoveBar(bar) end

---Set display maximum for all bars
---@param val number Maximum display value
function RarityBarContainerBarGroup:SetDisplayMax(val) end

---Force color update on all bars
function RarityBarContainerBarGroup:UpdateColors() end

---Set color at specific value point for gradient
---@param at number Value point (0-1)
---@param r number Red component (0-1)
---@param g number Green component (0-1)
---@param b number Blue component (0-1)
---@param a number Alpha component (0-1)
function RarityBarContainerBarGroup:SetColorAt(at, r, g, b, a) end

---Remove color at specific value point
---@param at number Value point to remove
function RarityBarContainerBarGroup:UnsetColorAt(at) end

---Remove all custom colors
function RarityBarContainerBarGroup:UnsetAllColors() end

---Show the anchor/drag handle
function RarityBarContainerBarGroup:ShowAnchor() end

---Hide the anchor/drag handle
function RarityBarContainerBarGroup:HideAnchor() end

---Check if anchor is visible
---@return boolean visible True if anchor is shown
function RarityBarContainerBarGroup:IsAnchorVisible() end

---Toggle anchor visibility
function RarityBarContainerBarGroup:ToggleAnchor() end

---Get position where next bar would attach
---@return number x X coordinate
---@return number y Y coordinate
function RarityBarContainerBarGroup:GetBarAttachPoint() end

---Set growth direction
---@param reverse boolean True for reverse growth
function RarityBarContainerBarGroup:ReverseGrowth(reverse) end

---Check if using reverse growth
---@return boolean reverse True if reverse growth
function RarityBarContainerBarGroup:HasReverseGrowth() end

---Update layout based on orientation
function RarityBarContainerBarGroup:UpdateOrientationLayout() end

---Set the group's length
---@param length number New length
function RarityBarContainerBarGroup:SetLength(length) end

---Get the group's length
---@return number length Current length
function RarityBarContainerBarGroup:GetLength() end

---Set the group's thickness
---@param thickness number New thickness
function RarityBarContainerBarGroup:SetThickness(thickness) end

---Get the group's thickness
---@return number thickness Current thickness
function RarityBarContainerBarGroup:GetThickness() end

---Set the group's orientation
---@param orientation RarityBarContainer.Orientation New orientation
function RarityBarContainerBarGroup:SetOrientation(orientation) end

---Get the group's orientation
---@return RarityBarContainer.Orientation orientation Current orientation
function RarityBarContainerBarGroup:GetOrientation() end

---Check if group is vertical
---@return boolean vertical True if vertical orientation
function RarityBarContainerBarGroup:IsVertical() end

---Set custom sorting function
---@param func function Sorting function that takes two bars and returns boolean
function RarityBarContainerBarGroup:SetSortFunction(func) end

---Sort all bars in the group
function RarityBarContainerBarGroup:SortBars() end

---No-op function for disabling sorting
function RarityBarContainerBarGroup.NOOP() end

---Set width (maps to length or thickness based on orientation)
---@param width number New width
function RarityBarContainerBarGroup:SetWidth(width) end

---Set height (maps to length or thickness based on orientation)
---@param height number New height
function RarityBarContainerBarGroup:SetHeight(height) end

-- ============================================================================
-- CALLBACK EVENTS
-- ============================================================================

---Bar callback events that can be registered
---@alias RarityBarContainer.BarEvent
---| "BarReleased" # Fired when bar is released back to pool
---| "AnimateFinished" # Fired when bar animation completes
---| "TimerStarted" # Fired when timer starts
---| "TimerStopped" # Fired when timer stops
---| "TimerFinished" # Fired when timer reaches zero
---| "FadeStarted" # Fired when fade begins
---| "FadeFinished" # Fired when fade completes
---| "FadeStopped" # Fired when fade is stopped
---| "FlashStarted" # Fired when flash begins
---| "FlashStopped" # Fired when flash stops

---Bar group callback events that can be registered
---@alias RarityBarContainer.GroupEvent
---| "AnchorMoved" # Fired when group anchor is moved
---| "AnchorClicked" # Fired when group anchor is clicked
---| "TimerFinished" # Fired when a timer bar finishes
---| "FadeFinished" # Fired when a bar fade finishes

-- ============================================================================
-- USAGE EXAMPLES
-- ============================================================================

--[[
-- Basic usage example:
local RarityBarContainer = Rarity.Utils.BarContainer

-- Embed into your addon
RarityBarContainer:Embed(MyAddon or table)

-- Create a bar group
local group = MyAddon:NewBarGroup("MyGroup", RarityBarContainer.LEFT_TO_RIGHT, 200, 20)

-- Create some bars
local healthBar = group:NewCounterBar("health", "Health", 100, 100, "Interface\\Icons\\Spell_ChargePositive")
local manaBar = group:NewCounterBar("mana", "Mana", 50, 100, "Interface\\Icons\\Spell_ChargeNegative")

-- Create a timer bar
local timerBar = group:NewTimerBar("buff", "Buff Duration", 30, 30, "Interface\\Icons\\Spell_Holy_Heal")

-- Update values
healthBar:SetValue(75)
manaBar:SetValue(80)
timerBar:SetTimer(25, 30)

-- Set colors
group:SetColorAt(0, 1, 0, 0, 1)    -- Red at 0%
group:SetColorAt(0.5, 1, 1, 0, 1)  -- Yellow at 50%
group:SetColorAt(1, 0, 1, 0, 1)    -- Green at 100%

-- Register callbacks
healthBar.RegisterCallback(MyAddon, "FadeFinished", function(event, bar, name)
    print("Health bar faded:", name)
end)

-- Show the anchor for positioning
group:ShowAnchor()
--]]

return RarityBarContainer

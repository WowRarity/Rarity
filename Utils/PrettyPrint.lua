  ----------------------------------------------------------------------------------------------------------------------
    -- This program is free software: you can redistribute it and/or modify
    -- it under the terms of the GNU General Public License as published by
    -- the Free Software Foundation, either version 3 of the License, or
    -- (at your option) any later version.

    -- This program is distributed in the hope that it will be useful,
    -- but WITHOUT ANY WARRANTY; without even the implied warranty of
    -- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    -- GNU General Public License for more details.

    -- You should have received a copy of the GNU General Public License
    -- along with this program.  If not, see <http://www.gnu.org/licenses/>.
----------------------------------------------------------------------------------------------------------------------

local addonName, addon = ...

-- Upvalues
local print = print
local format = format

-- Locals
local PP = {}

-- Prettified print
function PP.Print(msg, ...)
	print(format("|c00CC5500" .. "%s: " .. "|c00E6CC80%s", addonName, msg), ...)
end

-- Prints a prettier debug message, with source (module, category, etc.) if one was given
function PP.DebugMsg(msg, source, ...)

	source = source or ""
	print("|c00C2C2C2[" .. format(date("%H:%M:%S") .. "] " .. "|c000072CA" .. "%s: " .. "|c00E6CC80%s", addonName .. (source ~= "" and "_" .. source or ""), msg, ...))

end

addon.PrettyPrint = PP
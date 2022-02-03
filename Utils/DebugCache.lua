local addonName, addon = ...
if not addon then
	return
end

-- Upvalues
local tostring = tostring
local type = type
local tinsert = table.insert
local tremove = table.remove
local time = time
local min = min
local max = max

-- Locals
local DC = { messages = {}, print = print, cacheSize = 250 }

-- Prints a string representation of the internal state (not including the actual messages)
function DC:Debug()
	self.print("Settings: " .. "cacheSize = " .. tostring(self.cacheSize) .. ", numMessages = " ..
			           tostring(#self.messages))
end

-- Resets the state back to its default settings
function DC:Reset()
	self = DC
	self.print("Restored the cache to its default state")
end

-- Clears the debug stack, deleting all messages
function DC:Clear()
	self.messages = {}
	self.print("Cleared messages")
end

-- Prints number of cached debug messages to the output sink
function DC:PrintMessageCount()
	self.print("Number of stored messages: " .. tostring(#self.messages))
end

-- Prints cache size (number of messages that can be stored before they will be discarded)
function DC:PrintCacheSize()
	self.print("Cache size: " .. tostring(self.cacheSize))
end

-- Sets the cache size (will only accept positive numbers right now)
function DC:SetCacheSize(newCacheSize)
	-- Very basic sanity check (TODO I guess)
	local isNewCacheSizeValid = (type(newCacheSize) == "number" and newCacheSize > 0)
	if not isNewCacheSizeValid then
		self.print("Failed to set cache size to " .. tostring(newCacheSize))
		return
	end

	self.print("Cache size set to " .. tostring(newCacheSize) .. " (was " .. tostring(self.cacheSize) .. ")")
	self.cacheSize = newCacheSize
end

-- Sets the output handler (print replacement)
function DC:SetOutputHandler(outputHandler)
	-- Basic sanity check
	if type(outputHandler) ~= "function" then
		self.print("Failed to set new output handler: Not a function")
		return
	end

	self.print = outputHandler
end

-- AdDC a new message to the cache
function DC:AddMessage(text, category)
	category = category or "Debug"
	text = text or ""

	-- Create wrapper object
	local message = { text = text, category = category, timestamp = time() }

	-- Update cache
	if self.cacheSize == #self.messages then -- Drop first item (FIFO)
		tremove(self.messages, 1)
	end
	tinsert(self.messages, message)
end

-- Prints the last X messages (defaults to one message if the 'numMessages' parameter is omitted)
function DC:PrintMessages(numMessages)
	if #self.messages == 0 then
		self.print("Failed to print messages: Cache is currently empty")
		return
	end

	-- Show at least one message, but no more than are currently cached. Default to one message if no parameter was given
	numMessages = min(#self.messages, (type(numMessages) == "number" and numMessages > 0) and numMessages or 1)

	-- Show most recent messages first
	local firstIndex = max(#self.messages - numMessages, 1)
	local lastIndex = #self.messages

	for i = firstIndex, lastIndex do
		local msg = self.messages[i]
		local line = "(" .. tostring(i) .. ") - " .. tostring(msg.text)
		self.print(line, msg.timestamp, msg.category)
	end
end

Rarity.Utils.DebugCache = DC

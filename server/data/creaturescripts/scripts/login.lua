function onLogin(player)
	local loginStr = ""
	local timeZone = ""

	if player:getLastLoginSaved() <= 0 then
		loginStr = "Welcome to " .. configManager.getString(configKeys.SERVER_NAME) .. "!"
		loginStr = loginStr .. " Please choose your outfit."
		player:sendOutfitWindow()
	else
		if loginStr ~= "" then
			player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
		end

		if os.date("%Z").isdst ~= nil then
			timeZone = "CET"
		else
			timeZone = "CEST"
		end

		-- Your last visit in Tibia: 27. Aug 2016 02:48:14 Test.
		loginStr = string.format("Your last visit in " .. configManager.getString(configKeys.SERVER_NAME) .. ": %s " .. timeZone .. ".", os.date("%d. %b %Y %X", player:getLastLoginSaved()))
	end
	player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)

	-- Promotion
	local vocation = player:getVocation()
	local promotion = vocation:getPromotion()
	if player:isPremium() then
		local value = player:getStorageValue(STORAGEVALUE_PROMOTION)
		if not promotion and value ~= 1 then
			player:setStorageValue(STORAGEVALUE_PROMOTION, 1)
		elseif value == 1 then
			player:setVocation(promotion)
		end
	elseif not promotion then
		player:setVocation(vocation:getDemotion())
	end

	-- Events
	player:registerEvent("PlayerDeath")
	player:registerEvent("DropLoot")
	return true
end

local ShopItems = {}


function GetItemFromShop(Item, Zone)
	local item = {}
	local found = false
	for i=1, #Config.Zones[Zone].Items, 1 do
		if Config.Zones[Zone].Items[i].name == Item then
			item = Config.Zones[Zone].Items[i]
			found = true
			break
		end
	end

	if found then 
		return true, item.price, item.label
	else
		return false
	end
end


RegisterServerEvent('esx_shops:buyItem')
AddEventHandler('esx_shops:buyItem', function(itemName, amount, zone)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local Exists, price,label = GetItemFromShop(itemName,zone)
	amount = ESX.Math.Round(amount)

	if amount < 0 then
		print('esx_shops: ' .. xPlayer.identifier .. ' attempted to exploit the shop!')
		return
	end

	if not Exists then
		print('esx_shops: ' .. xPlayer.identifier .. ' attempted to exploit the shop!')
		return
	end

	if Exists then
		price = price * amount
	-- can the player afford this item?
		if xPlayer.getMoney() >= price then
			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, amount) then
				xPlayer.removeMoney(price)
				xPlayer.addInventoryItem(itemName, amount)
				xPlayer.showNotification(_U('bought', amount, label, ESX.Math.GroupDigits(price)))
			else
				xPlayer.showNotification(_U('player_cannot_hold'))
			end
		else
			local missingMoney = price - xPlayer.getMoney()
			xPlayer.showNotification(_U('not_enough', ESX.Math.GroupDigits(missingMoney)))
		end
	end
end)

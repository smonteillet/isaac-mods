local bookMod = RegisterMod("BookOfLamentations",1)
local bookItem = Isaac.GetItemIdByName("Book of lamentations")

bookMod.debug=false
bookMod.debugStr="Init"

function bookMod:useBook()
	local player = Isaac.GetPlayer(0)
   	player:AddCacheflag(CacheFlag.CACHE_FIREDELAY)
	player:EvaluateItems()
	return true
end

function bookMod:updateStats()
	if cacheFlag == CacheFlags.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay - 3
    end
end

function mod:debug()
	if bookMod.debug then
		Isaac.RenderText(bookMod.debugStr, 50, 15, 255, 255, 255, 255)
	end
end

bookMod:AddCallback(ModCallbacks.MC_POST_UPDATE, bookMod.debug)
bookMod:AddCallback(ModCallbacks.MC_USE_ITEM, bookMod.useBook, bookItem)
bookMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, bookMod.updateStats)

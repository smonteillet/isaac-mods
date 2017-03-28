local bookOfLamentations = RegisterMod("BookOfLamentations",1)

local bookOfLamentationsItem = Isaac.GetItemIdByName("Book of lamentations")

function bookOfLamentations:UseBook()
	local player = Isaac.GetPlayer(0)
	if cacheFlag == CacheFlag.CACHE_FIREDELAY then
	 	player.FireDelay = player.FireDelay - 3;
	end
end

bookOfLamentations:AddCallback(ModCallbacks.MC_USE_ITEM, bookOfLamentations.UseBook, bookOfLamentationsItem)
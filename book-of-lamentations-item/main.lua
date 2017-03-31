
local mod = RegisterMod("BookOfLamentations",1)

local bookOfLamentations = {
	itemID = Isaac.GetItemIdByName("Book of lamentations");
	isActive = false;
}


function mod:useItem(CollectibleType, RNG)
	local player = Isaac.GetPlayer(0)
	player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
	player:EvaluateItems()
	bookOfLamentations.isActive = true;
	return true
end

function mod:evaluateCache(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FIREDELAY and
	   player:HasCollectible(bookOfLamentations.itemID) and
		 bookOfLamentations.isActive then
		player.MaxFireDelay = player.MaxFireDelay - 3;
	end
end

function mod:postUpdate()
	if mod:hasPlayerJustEnterARoom() and bookOfLamentations.isActive then
    bookOfLamentations.isActive = false;
    local player = Isaac.GetPlayer(0);
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY);
    player:EvaluateItems();
  end
end

function mod:hasPlayerJustEnterARoom()
	return Game():GetRoom():GetFrameCount() == 1
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.postUpdate)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.useItem, bookItem)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.evaluateCache)

local mod = RegisterMod("BookOfLamentations",1)

local bookOfLamentations = {
	itemID = Isaac.GetItemIdByName("Book of lamentations");
	isActive = false;
	debugStr="nothing";
	TEAR_DELAY_HARD_CAP = 5;
	TEAR_DELAY_TO_REMOVE_BY_ITEM_USE = 3;
}


function mod:useItem(CollectibleType, RNG)
	bookOfLamentations.debugStr="1"
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(bookOfLamentations.itemID) then
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
		bookOfLamentations.isActive = true
		bookOfLamentations.debugStr="2"
		if mod:replaceDevilDealByAngelDealIfPossible() then
			Game():GetLevel():AddAngelRoomChance(1.0)
		end
	end
	return true
end

function mod:replaceDevilDealByAngelDealIfPossible(stage)
	local stage = Game():GetLevel():GetStage()
	local isBossFight = Game():GetRoom():IsCurrentRoomLastBoss()
	return isBossFight and (
		stage == LevelStage.STAGE1_2 or
		stage == LevelStage.STAGE2_1 or
		stage == LevelStage.STAGE2_2 or
		stage == LevelStage.STAGE3_1 or
		stage == LevelStage.STAGE3_2 or
		stage == LevelStage.STAGE4_1 or
		stage == LevelStage.STAGE4_2 or
		stage == LevelStage.STAGE1_GREED or
		stage == LevelStage.STAGE2_GREED or
		stage == LevelStage.STAGE3_GREED or
		stage == LevelStage.STAGE4_GREED or
		stage == LevelStage.STAGE5_GREED or
		stage == LevelStage.STAGE6_GREED
	)
end

function mod:evaluateCache(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FIREDELAY and player:HasCollectible(bookOfLamentations.itemID) and bookOfLamentations.isActive then
		local playerMaxFireDelay = player.MaxFireDelay - bookOfLamentations.TEAR_DELAY_TO_REMOVE_BY_ITEM_USE
		if playerMaxFireDelay < bookOfLamentations.TEAR_DELAY_HARD_CAP then
			playerMaxFireDelay = bookOfLamentations.TEAR_DELAY_HARD_CAP
		end
		player.MaxFireDelay = playerMaxFireDelay
	end
end

function mod:postUpdate()
	if mod:hasPlayerJustEnterARoom() then
		bookOfLamentations.debugStr="0"
	end
	Isaac.RenderText("DebugStr: "..bookOfLamentations.debugStr, 50, 30, 255, 255, 255, 255)
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

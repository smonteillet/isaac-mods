local mod = RegisterMod("BookOfLamentations",1)


local stagesWithPossibleDevilDeals = {
	[LevelStage.STAGE1_2] = true,
	[LevelStage.STAGE2_1] = true,
	[LevelStage.STAGE2_2] = true,
	[LevelStage.STAGE3_1] = true,
	[LevelStage.STAGE3_2] = true,
	[LevelStage.STAGE4_1] = true,
	[LevelStage.STAGE4_2] = true
}

local greedModeStagesWithPossibleDevilDeals = {
	[LevelStage.STAGE1_GREED] = true,
	[LevelStage.STAGE2_GREED] = true,
	[LevelStage.STAGE3_GREED] = true,
	[LevelStage.STAGE4_GREED] = true,
	[LevelStage.STAGE5_GREED] = true,
	[LevelStage.STAGE6_GREED] = true
}

local bookOfLamentations = {
	itemID = Isaac.GetItemIdByName("Book of lamentations");
	isActive = false;
	TEAR_DELAY_HARD_CAP = 5;
	TEAR_DELAY_TO_REMOVE_BY_ITEM_USE = 3;
	debug = false,
	debugStr = "debug"
}


function mod:useItem(CollectibleType, RNG)
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(bookOfLamentations.itemID) then
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
		bookOfLamentations.isActive = true
		if mod:canRoomHaveDevilDealSpawn() then
			Game():GetLevel():AddAngelRoomChance(1.0)
		end
	end
	return true
end

function mod:canRoomHaveDevilDealSpawn(stage)
	local stage = Game():GetLevel():GetStage()
	local isBossFight = Game():GetRoom():IsCurrentRoomLastBoss()
	local stageCanHaveDevilDeal = stagesWithPossibleDevilDeals[stage]
	if Game():IsGreedMode() then
		stageCanHaveDevilDeal = greedModeStagesWithPossibleDevilDeals[stage]
	end
	return isBossFight and stageCanHaveDevilDeal
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
	if debug then
		Isaac.RenderText("DebugStr: "..debugStr, 50, 30, 255, 255, 255, 255)
	end
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

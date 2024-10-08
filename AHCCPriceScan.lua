local AHCC = LibStub("AceAddon-3.0"):GetAddon("AHCC")
local L, _ = AHCC:GetLibs()


AHCCPriceScanMixin = {}

function AHCCPriceScanMixin:OnLoad()
   -- self.items = AHCCItems:getAll()
end

function AHCCPriceScanMixin:OnShow()
    self:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED");
    -- local items = AHCCItems:getAll()
    self.chunks = _.chunk(self.items, 50)
    self.progress = 0
    self.total = #self.chunks
    
    self:Perform()


    C_Timer.After(20, function()
        if self.progress >= self.total then return end
        self:Done()
    end)
end





function AHCCPriceScanMixin:Done()
    self:Hide()
   
    AuctionHouseFrame.BrowseResultsFrame:Reset()
    AuctionHouseFrame.BrowseResultsFrame.ItemList:DirtyScrollFrame();
    AHCC:performSearch(true)
end

function AHCCPriceScanMixin:OnHide()
    self:UnregisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED");
end

function AHCCPriceScanMixin:OnEvent(event)
    local items =  AuctionHouseFrame.BrowseResultsFrame.browseResults
    _.forEach(items, function(item)
        AHCCItems:updatePrice(item.itemKey.itemID, item.minPrice)
    end)

    if self.progress == self.total then 
        self:Done()
        return
    end

    self:Perform()
end

function AHCCPriceScanMixin:Perform()
    if self.progress == self.total then return end
    self.progress = self.progress + 1

    local items = CopyTable(self.chunks[self.progress])
    local ItemKeys = {}
    _.forEach(items, function(item) 
        local itemKey = C_AuctionHouse.MakeItemKey(item.itemKey.itemID)
        table.insert(ItemKeys, itemKey)
    end)

    local sorts = {
        {sortOrder = Enum.AuctionHouseSortOrder.Price, reverseSort = false},
        {sortOrder = Enum.AuctionHouseSortOrder.Name, reverseSort = false},
    }


    --@do-not-package@
       --DevTool:AddData(items,  self.progress)
    --@end-do-not-package@

    C_AuctionHouse.SearchForItemKeys(ItemKeys, sorts)
end
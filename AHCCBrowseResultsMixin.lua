local AHCC = LibStub("AceAddon-3.0"):GetAddon("AHCC")
local L, _ = AHCC:GetLibs()


local AuctionHouseSortOrderState = tInvert({
	"None",
	"PrimarySorted",
	"PrimaryReversed",
	"Sorted",
	"Reversed",
});



local function AddFixedWidthColumn(AHCC, owner, tableBuilder, key)
    if not _.has(AHCC.Config.TableColums, {key}) then return end
    local colConfig = AHCC.Config.TableColums[key]
    local column = tableBuilder:AddFixedWidthColumn(owner, colConfig.padding, colConfig.width, colConfig.leftCellPadding, colConfig.rightCellPadding, Enum.AuctionHouseSortOrder[key], string.format("AuctionHouseTableCell%sTemplate", key));
    column:GetHeaderFrame():SetText(colConfig.name);
end

local function GetBrowseListLayout(AHCC, owner, itemList)

	local function LayoutBrowseListTableBuilder(tableBuilder)
		tableBuilder:SetColumnHeaderOverlap(2);
		tableBuilder:SetHeaderContainer(itemList:GetHeaderContainer());

        _.forEach(AHCCCategory.config:getColumns(AHCC.Nav), function(colName)
            if colName == "Price" then 
                tableBuilder:AddFixedWidthColumn(owner, PRICE_DISPLAY_PADDING, 146, 0, 14, Enum.AuctionHouseSortOrder.Price , "AHCCTableCellMoneyTemplate");
            elseif colName == "Name" then 
                local nameColumn = tableBuilder:AddFillColumn(owner, 0, 1.0, 14, 14, Enum.AuctionHouseSortOrder.Name, "AuctionHouseTableCellItemDisplayTemplate");
                nameColumn:GetHeaderFrame():SetText(AUCTION_HOUSE_BROWSE_HEADER_NAME);
            else
                AddFixedWidthColumn(AHCC, owner, tableBuilder, colName)
            end
        end)
	end

	return LayoutBrowseListTableBuilder;
end



AHCCBrowseResultsMixin  = CreateFromMixins(AuctionHouseSortOrderSystemMixin);

function AHCCBrowseResultsMixin:SetupTableBuilder()
    self.ItemList:SetTableBuilderLayout(GetBrowseListLayout(AHCC, self, self.ItemList));

	self.tableBuilderLayoutDirty = false;
end

function AHCCBrowseResultsMixin:OnLoad()
    self:SetParent(AuctionHouseFrame.CategoriesList)

    self:SetFrameLevel(10)
    AuctionHouseSortOrderSystemMixin.OnLoad(self);

	self.ItemList:SetLineTemplate("AuctionHouseFavoritableLineTemplate");

	self.ItemList:SetSelectionCallback(function(browseResult)
		AuctionHouseFrame:SelectBrowseResult(browseResult);
        self:Hide()
		return false;
	end);

	self.ItemList:SetLineOnEnterCallback(AuctionHouseUtil.LineOnEnterCallback);
	self.ItemList:SetLineOnLeaveCallback(AuctionHouseUtil.LineOnLeaveCallback);

    self:SetupTableBuilder();

    

    self.searchStarted =  true
    self.browseResults = {}

    
	local function BrowseListSearchStarted()
		return self.searchStarted, AUCTION_HOUSE_BROWSE_FAVORITES_TIP;
	end

	local function BrowseListGetNumEntries()
		return #self.browseResults;
	end

	local function BrowseListGetEntry(index)
		return self.browseResults[index];
	end

    local function hasFullResultsFun()
		return false
	end

	self.ItemList:SetDataProvider(BrowseListSearchStarted, BrowseListGetEntry, BrowseListGetNumEntries, hasFullResultsFun);
	self:Reset();
end

function AHCCBrowseResultsMixin:Reset()
	self.browseResults = {};
	self.sortOrder = nil;
	self.isSortOrderReversed = false;
	self.searchStarted = false;
end

function AHCCBrowseResultsMixin:Update(items)
    self.sortOrder = 1 --AHCC.db.global.sort[1].sortOrder
    self.ItemList:SetRefreshCallback(nil)
    self.searchStarted = true;
    self.browseResults = items
    self:UpdatePrices()

    self:SetupTableBuilder();
    self:Sort();
    self.ItemList:Reset();
    self.ItemList:DirtyScrollFrame();
end


function AHCCBrowseResultsMixin:Refresh(items)
    self.browseResults = items
    self:Sort();
    self.ItemList:DirtyScrollFrame();
end


local function GetSortOrderState(sortOrder)
	local sorts = AHCC.db.global.sort
	if not sorts then
		return AuctionHouseSortOrderState.None;
	end

	for i, sortType in ipairs(sorts) do
		if sortType.sortOrder == sortOrder then
			if sortType.reverseSort then
				return (i == 1) and AuctionHouseSortOrderState.PrimaryReversed or AuctionHouseSortOrderState.Reversed;
			else
				return (i == 1) and AuctionHouseSortOrderState.PrimarySorted or AuctionHouseSortOrderState.Sorted;
			end
		end
	end

	return AuctionHouseSortOrderState.None;
end

function AHCCBrowseResultsMixin:SetSortOrder(sortOrder)
    local sort1 = AHCC.db.global.sort[1]
    sort1.reverseSort = sort1.sortOrder == sortOrder and not sort1.reverseSort
    sort1.sortOrder = sortOrder

    AHCC.db.global.sort = {
        sort1,
        AHCC.db.global.sort[2]
    }

    self:Sort(sortOrder)
	self:UpdateHeaders();
end

function AHCCBrowseResultsMixin:GetSortOrderState(sortOrder)
	return GetSortOrderState(sortOrder)
end

function AHCCBrowseResultsMixin:Sort(sortOrder)
    local sorts = AHCC.db.global.sort
   
    local function getKey(idx)
        return _.findKey(Enum.AuctionHouseSortOrder, function(v) return v == sorts[idx].sortOrder end)
    end

    local priComp = (sorts[1] and sorts[1].reverseSort) and _.gt or _.lt
    local comp = (sorts[2] and sorts[2].reverseSort) and _.gt or _.lt

    local k1 = getKey(1)
    local k2 = getKey(2)

    table.sort(self.browseResults, function (a, b)
        if not a[k1] then return false end
        if not b[k1] then return false end

        if #sorts == 1 then 
            return  priComp(a[k1], b[k1])
        else
            if not a[k2] then return false end
            if not b[k2] then return false end
            return  priComp(a[k1], b[k1]) or 
                ( a[k1] == b[k1] and comp(a[k2], b[k2]))
        end
    end)

    self.ItemList:DirtyScrollFrame();
end


function AHCCBrowseResultsMixin:OnShow()
	self.ItemList:RefreshScrollFrame();
end

function AHCCBrowseResultsMixin:OnHide()
end

function AHCCBrowseResultsMixin:OnEvent(event, ...)
	
end

function AHCCBrowseResultsMixin:UpdatePrices(force)
    local updateNeeded = force and true or false

    if not force then 
        _.forEach(self.browseResults, function(item)
            if updateNeeded then return end
            if item.minPrice == -1 and not updateNeeded then updateNeeded = true return end
        end)
    end

    if not updateNeeded then return end

    -- run that update 

    AHCC.PriceScan.items = CopyTable(self.browseResults)
    AHCC.PriceScan:Show()
	
end
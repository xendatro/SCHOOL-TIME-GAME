local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TagService = require(ReplicatedStorage.Services.TagService)

local Settings = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated.Settings.Settings)

local Root = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated.Classes.Root)

local Tab = require(ReplicatedStorage.Frameworks.xenterfaceDeprecated.Modules.Tab)
local table = require(ReplicatedStorage.Libraries.table)

local Page = {}

function Page:Start()
	Page.Connections = {
		Clicked = Tab.Clicked:Connect(function(guiButton: GuiButton, root: Instance)
			local groupID = guiButton:GetAttribute(Settings.Page_GroupID)
			local pageID = guiButton:GetAttribute(Settings.Page_ID)
			local tabTag = Settings.TabTag
			local pageTag = Settings.PageTag
			
			local shownTabs = TagService:GetTaggedOfPredicate(Settings.TabTag, function(tab: GuiButton)
				return tab:GetAttribute(Settings.Page_GroupID) == groupID 
					and tab:GetAttribute(Settings.Page_ID) == pageID
					and tab:IsDescendantOf(root)
			end)
			local shownTab = Root:GetFunction(root, "Page", "ShownTab", groupID)
			for k, v in shownTabs do
				shownTab(v, guiButton)
			end

			local hiddenTabs = TagService:GetTaggedOfPredicate(Settings.TabTag, function(tab: GuiButton)
				return tab:GetAttribute(Settings.Page_GroupID) == groupID 
					and tab:GetAttribute(Settings.Page_ID) ~= pageID
					and tab:IsDescendantOf(root)
			end)
			local hiddenTab = Root:GetFunction(root, "Page", "HiddenTab", groupID)
			for k, v in hiddenTabs do
				hiddenTab(v, guiButton)
			end
			
			local pages = TagService:GetTaggedOfPredicate(Settings.PageTag, function(page)
				return page:IsDescendantOf(root) 
					and page:GetAttribute(Settings.Page_GroupID) == groupID
			end)
			
			local shownPages = {}
			local hiddenPages = {}
			
			for i, page in pages do
				local mode = page:GetAttribute(Settings.Page_Mode)
				if mode == "Radio" or mode == nil then
					if page:GetAttribute(Settings.Page_ID) == pageID then
						table.insert(shownPages, page)
					else
						table.insert(hiddenPages, page)
					end
				elseif mode == "Toggle" then
					if page:GetAttribute(Settings.Page_Shown) == false and page:GetAttribute(Settings.Page_ID) == pageID then
						table.insert(shownPages, page)
					else
						table.insert(hiddenPages, page)
					end
				elseif mode == "Multi" then
					if page:GetAttribute(Settings.Page_Shown) == false and page:GetAttribute(Settings.Page_ID) == pageID 
						or page:GetAttribute(Settings.Page_Shown) and page:GetAttribute(Settings.Page_ID) ~= pageID
					then
						table.insert(shownPages, page)
					else
						table.insert(hiddenPages, page)
					end
				end
			end
			
			local shownPage = Root:GetFunction(root, "Page", "ShownPage", groupID)
			for i, page in shownPages do
				if page:GetAttribute(Settings.Page_Shown) ~= nil then
					page:SetAttribute(Settings.Page_Shown, true)
				end
				shownPage(page)
			end
			
			local hiddenPage = Root:GetFunction(root, "Page", "HiddenPage", groupID)
			for i, page in hiddenPages do
				if page:GetAttribute(Settings.Page_Shown) ~= nil then
					page:SetAttribute(Settings.Page_Shown, false)
				end
				hiddenPage(page)
			end
			
		end)
	}
end

function Page:Stop()
	table.fullclear(Page.Connections)
end

return Page
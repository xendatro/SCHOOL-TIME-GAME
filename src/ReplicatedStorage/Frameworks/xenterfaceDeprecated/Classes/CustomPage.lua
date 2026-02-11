local CustomPage = {}
CustomPage.__index = CustomPage

type CustomPage = {
	ShownTab: (shownTab: GuiButton, tabSelected: GuiButton) -> nil,
	ShownPage: (shownPage: GuiObject, tabSelected: GuiButton) -> nil,
	HiddenTab: (hiddenTab: GuiButton, tabSelected: GuiButton) -> nil,
	HiddenPage: (hiddenPage: GuiObject, tabSelected: GuiButton) -> nil
}

function CustomPage.new(): CustomPage
	local self = setmetatable({}, CustomPage)
	
	return self
end

return CustomPage
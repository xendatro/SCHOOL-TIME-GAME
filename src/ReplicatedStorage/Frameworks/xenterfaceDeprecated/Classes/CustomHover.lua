local CustomHover = {}
CustomHover.__index = CustomHover

type CustomHover = {
	Entered: (guiButton: GuiButton) -> nil,
	Left: (guiButton: GuiButton) -> nil
}

function CustomHover.new(): CustomHover
	local self = setmetatable({}, CustomHover)
	
	return self
end


return CustomHover
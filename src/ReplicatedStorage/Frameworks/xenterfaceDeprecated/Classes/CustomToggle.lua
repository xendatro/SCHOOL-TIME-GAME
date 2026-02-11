local CustomToggle = {}
CustomToggle.__index = CustomToggle

type CustomToggle = {
	OpenedToggleable: (toggleable: GuiObject) -> nil,
	ClosedToggleable: (toggleable: GuiObject) -> nil
}

function CustomToggle.new(): CustomToggle
	local self = setmetatable({}, CustomToggle)

	
	return self
end

return CustomToggle
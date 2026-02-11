local UserInputService = game:GetService("UserInputService")


UserInputService.InputBegan:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.Keyboard then
		script.Parent.Text = "Press [Backspace] to drop item!"
	elseif inputObject.UserInputType == Enum.UserInputType.Gamepad1 then
		script.Parent.Text = "Press [B/O] to drop item!"
	elseif inputObject.UserInputType == Enum.UserInputType.Touch then
		script.Parent.Text = ""
	end	
end)
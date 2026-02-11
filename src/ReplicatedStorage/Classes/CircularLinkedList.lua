local CircularLinkedList = {}
CircularLinkedList.__index = CircularLinkedList

local Link = {}
Link.__index = Link

function Link.new(data)
	local self = setmetatable({}, Link)

	self.Data = data

	return self
end

local Iterator = {}
Iterator.__index = Iterator

function Iterator.new(link)
	local self = setmetatable({}, Iterator)

	self.CurrentLink = link

	return self
end

function Iterator:Get()
	return self.CurrentLink.Data
end

function Iterator:Next()
	self.CurrentLink = self.CurrentLink.Next
end

function Iterator:Previous()
	self.CurrentLink = self.CurrentLink.Previous
end

function CircularLinkedList.new(data)
	local self = setmetatable({}, CircularLinkedList)

	local last = nil
	for i, v in data do
		local link = Link.new(v)
		if last then
			link.Previous = last
			last.Next = link
		else
			self.Head = link
		end
		if i == #data then
			link.Next = self.Head
			self.Head.Previous = link
		end
		last = link
	end

	return self
end

function CircularLinkedList:GetIterator()
	return Iterator.new(self.Head)
end

return CircularLinkedList
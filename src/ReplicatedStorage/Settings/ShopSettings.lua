local ShopSettings = {}

ShopSettings.Items = {
	Key = {
		Price = 2,
		Description = "Use a key to unlock a locker, which sometimes has good loot!"
	},
	Soda = {
		Price = 5,
		Description = "Drink a soda to gain a temporary speed boost to escape from the teacher!"
	},
	Trap = {
		Price = 6,
		Description = "Place down a trap to temporarily immobilize a teacher!"
	},
	SpellBook = {
		Price = 6,
		Description = "Use a spell book to become temporarily immune to damage!"
	},
	Ball = {
		Price = 7,
		Description = "Throw a paper ball at a teacher to stun them temporarily!"
	},
	Shovel = {
		Price = 12,
		Description = "Use a shovel to dig to create tunnels through the map!"
	},
	Lantern = {
		Price = 8,
		Description = "Use a lantern for better visibility!"
	},
	Bandage = {
		Price = 4,
		Description = "Use a bandage to heal 10 hp!"
	},
	Medkit = {
		Price = 9,
		Description = "Use a medkit to heal 45 hp!"
	}
}

function ShopSettings:GetPriceFromQuantity(itemName: string, quantity: number)
	return ShopSettings.Items[itemName].Price * quantity
end

return ShopSettings
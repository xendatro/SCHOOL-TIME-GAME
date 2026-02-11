local ShopSettings = {}

ShopSettings.Kits = {
	{
		Name = "Soda Addict",
		Order = 1,
		Cost = 3,
		Description = "This guy should drink more water... +5% walk speed, -10% max health",
		Items = {
			{
				Name = "Soda",
				Amount = 1
			}
		},
		Image = "http://www.roblox.com/asset/?id=114890031300545",
		Perks = {
			WalkSpeed = 1,
			MaxHealth = -10
		}
	},
	{
		Name = "Class Clown",
		Order = 2,
		Cost = 5,
		Description = "Stop throwing paper balls at the teacher!!",
		Items = {
			{
				Name = "Ball",
				Amount = 1
			},
			{
				Name = "Key",
				Amount = 1
			}
		},
		Image = "http://www.roblox.com/asset/?id=137676635097082",
		Perks = {
			WalkSpeed = 0,
			MaxHealth = 0
		}
	},
	{
		Name = "School Nurse",
		Order = 3,
		Cost = 8,
		Description = "Just put an ice pack on it. Heal your friends and outsmart the teachers! -5% walk speed, +20% max health",
		Items = {
			{
				Name = "Bandage",
				Amount = 4
			}
		},
		Image = "http://www.roblox.com/asset/?id=90578027551029",
		Perks = {
			WalkSpeed = -1,
			MaxHealth = 20
		}
	},
	{
		Name = "Bully",
		Order = 4,
		Cost = 10,
		Description = "Toy Factory Tycoon > the fun obby > prop blast > Framed > Bullying -11% walk speed, +25% max health",
		Items = {
			{
				Name = "Soda",
				Amount = 2,
			},
			{
				Name = "Ball",
				Amount = 1
			}
		},
		Image = "http://www.roblox.com/asset/?id=131716261972852",
		Perks = {
			WalkSpeed = -2,
			MaxHealth = 25
		}
	},
	{
		Name = "Hunter",
		Order = 5,
		Cost = 12,
		Description = "Why does this guy have so many bear traps? -5% walk speed, +20% max health",
		Items = {
			{
				Name = "Trap",
				Amount = 5
			}
		},
		Image = "http://www.roblox.com/asset/?id=73296162191531",
		Perks = {
			WalkSpeed = 1,
			MaxHealth = 20
		}
	},
	{
		Name = "Principal's Child",
		Order = 6,
		Cost = 15,
		Description = "Apparently this is the principal's child. That's how they have so many keys. +5% walk speed, +10% max health",
		Items = {
			{
				Name = "Key",
				Amount = 6
			},
			{
				Name = "Shovel",
				Amount = 1
			}
		},
		Image = "http://www.roblox.com/asset/?id=79060662693846",
		Perks = {
			WalkSpeed = 1,
			MaxHealth = 10
		}
	},
	{
		Name = "Skater",
		Order = 7,
		Cost = 25,
		Description = "She's not a poser, you are.",
		Items = {
			{
				Name = "Soda",
				Amount = 4
			},
			{
				Name = "Medkit",
				Amount = 1
			}
		},
		Image = "http://www.roblox.com/asset/?id=138682568387068",
		Perks = {
			WalkSpeed = 0,
			MaxHealth = 0
		}
	},
	{
		Name = "akro",
		Order = 8,
		Cost = 30,
		Description = "Hello it's me tekken i spam xendatro with reels on ig (he does not watch) +17% walk speed",
		Items = {
			{
				Name = "Shovel",
				Amount = 1
			},
			{
				Name = "Key",
				Amount = 4
			},
			{
				Name = "Ball",
				Amount = 2
			}
		},
		Image = "http://www.roblox.com/asset/?id=130228173373815",
		Perks = {
			WalkSpeed = 3,
			MaxHealth = 0
		}
	},
	{
		Name = "Wizard",
		Order = 9,
		Cost = 35,
		Description = "School wizard hired by the principal himself. +17% walk speed, +10% max health",
		Items = {
			{
				Name = "SpellBook",
				Amount = 3
			},
			{
				Name = "Medkit",
				Amount = 2
			},
			{
				Name = "Lantern",
				Amount = 1
			}
		},
		Image = "http://www.roblox.com/asset/?id=103463122573778",
		Perks = {
			WalkSpeed = 3,
			MaxHealth = 10
		}
	},
	{
		Name = "Tim Cheese",
		Order = 10,
		Cost = 40,
		Description = "Shady character... he's got gadgets. +22% walk speed, +40% max health",
		Items = {
			{
				Name = "Shovel",
				Amount = 2
			},
			{
				Name = "Medkit",
				Amount = 3
			},
			{
				Name = "Ball",
				Amount = 2
			}
		},
		Image = "http://www.roblox.com/asset/?id=101837835159773",
		Perks = {
			WalkSpeed = 4,
			MaxHealth = 40
		}
	},
	{
		Name = "Randy",
		Order = 11,
		Cost = 80,
		Description = "Hello MrRubberPig this kit was made for you. +22% walk speed, +80% max health",
		Items = {
			{
				Name = "Shovel",
				Amount = 6
			}
		},
		Image = "http://www.roblox.com/asset/?id=89142506415936",
		Perks = {
			WalkSpeed = 4,
			MaxHealth = 80
		}
	},
	{
		Name = "Rich Kid",
		Order = 14,
		Cost = "VIP",
		Type = "VIP",
		Items = {
			{
				Name = "Coin",
				Amount = 70
			}	
		},
		Description = "hey guys it's me *salutes* +17% walk speed, +50% max health",
		Image = "http://www.roblox.com/asset/?id=82018633653234",
		Perks = {
			WalkSpeed = 3,
			MaxHealth = 50
		}
	},
	{
		Name = "Hustlin",
		Order = 12,
		Cost = 199,
		Type = "Robux",
		Items = {
			{
				Name = "Coin",
				Amount = 50
			},
			{
				Name = "Ball",
				Amount = 5
			},
			{
				Name = "Medkit",
				Amount = 2
			}
		},
		Description = "Builder of the game! Every single model in this game was modeled by this guy. +28% walk speed, +100% max health",
		Image = "http://www.roblox.com/asset/?id=113329602557583",
		PassId = 1161636456,
		Perks = {
			WalkSpeed = 5,
			MaxHealth = 100
		}
	},
	{
		Name = "xendatro",
		Order = 13,
		Cost = 199,
		Type = "Robux",
		Items = {
			{
				Name = "Coin",
				Amount = 50
			},
			{
				Name = "Medkit",
				Amount = 5
			},
			{
				Name = "Trap",
				Amount = 2
			}
		},
		Description = "what's the car for 210 +28% walk speed, +100% max health",
		Image = "http://www.roblox.com/asset/?id=135159367335010",
		PassId = 1161480432,
		Perks = {
			WalkSpeed = 5,	
			MaxHealth = 100
		}
	}
}


return ShopSettings
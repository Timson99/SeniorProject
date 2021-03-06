extends Object

class_name ItemsDirectory

const items = {
  "Crappy Spatula": {
	"Description": "This crappy looking spatula gives you no pride.",
	"Type": "WPN",
	"stat-mod": { "Attack": 1 }
  },

  "Leaf Bag": {
	"Description": "A leaf bag. Effective against leaves.",
	"Type": "ARM",
	"stat-mod": { "Defense": 1 }
  },

  "Milk Carton": {
	"Description": "+1 HP. It's good for your bones. ",
	"Type": "USE-HEAL",
	"recovery-mod": { "HP": 1 }
  },

  "Peach Iced Tea": {
	"Description": "+5 HP. Sweet. Refreshing. Artificially flavored.",
	"Type": "USE-HEAL",
	"recovery-mod": { "HP": 5 }
  },

  "Bomb": {
	"Description": "5 pts kaboom damage.",
	"Type": "USE-DMG",
	"damage-mod": { "HP": -5 }
  },

  "Scissors": {
	"Description": "A pair of Scissors.",
	"Type": "KEY"
  }
}

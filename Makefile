all: game.js
	
game.js: game.coffee 
	coffee -bc game.coffee

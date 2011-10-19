all: game.js tests.js
	
game.js: game.coffee 
	coffee -bc game.coffee

tests.js: tests.coffee
	coffee -bc tests.coffee

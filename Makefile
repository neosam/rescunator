all: game.js tests.js animations.js
	
game.js: game.coffee 
	coffee -bc game.coffee

tests.js: tests.coffee
	coffee -bc tests.coffee

animations.js: animations.coffee
	coffee -bc animations.coffee

clean:
	rm -f game.js tests.js animations.js

engine = null

class Item
    constructor: (@x = 0, @y = 0, @width = 32, @height = 32) ->
        @htmlElem = $ '<div>'
        @htmlElem.css 'position', 'relative'
        @htmlElem.css 'left', @x
        @htmlElem.css 'top', @y
        @htmlElem.css 'width', @width
        @htmlElem.css 'height', @height
        @setTexture('graphics.png')
        @setAnimation(0, 0, 1)

    setPosition: (@x, @y) ->
        @htmlElem.css 'left', @x
        @htmlElem.css 'top', @y

    setTexture: (@textureName) ->
        @htmlElem.css 'background-image', "url(#{@textureName})"
        @setTexturePos(0, 0)
    
    setTexturePos: (@textureX, @textureY) ->
        @htmlElem.css 'background-position', "#{-@textureX}px #{-@textureY}px"

    setAnimation: (@animationStartX, @animationStartY, @animationSteps) ->
        @animationCurrentStep = -1
    
    nextFrame: ->
        @animationCurrentStep = (@animationCurrentStep + 1) % @animationSteps
        @setTexturePos  @animationStartX + @animationCurrentStep * @width, \
                        @animationStartY

class RescEngine
    constructor: (@fieldid, @width, @height) ->
        @field = $ @fieldid
        @field.css 'width', @width + 'px'
        @field.css 'height', @height + 'px'
        @field.css 'border', 'solid black 1px'
        @field.css 'display', 'block'
        @field.css 'overflow', 'hidden'

        @staticItems = []

    addStaticItem: (item) ->
        @staticItems.push(item)
        @field.append(item.htmlElem)

    nextFrame: ->
        item.nextFrame() for item in @staticItems

$(document).ready ->
    engine = new RescEngine '#gamefield', 800, 600
    item = new Item
    item2 = new Item 100, 100
    item3 = new Item 250, 444
    item4 = new Item 555, 100
    engine.addStaticItem item
    engine.addStaticItem item2
    engine.addStaticItem item3
    engine.addStaticItem item4

    item2.setTexturePos 32, 0
    item3.setTexturePos 64, 0
    item4.setTexturePos 94, 0

    item.setAnimation 0, 0, 3

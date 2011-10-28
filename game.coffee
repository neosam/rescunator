engine = null

oneDCollision = (p1, w1, p2, w2) ->
    size = w1 + w2
    d1 = p2 + w2 - p1
    d2 = p1 + w1 - p2
    if (0 < d1 < size or 0 < d2 < size)
        return true
    return false

rectCollision = (r1, r2)->
    return oneDCollision(r1.x, r1.width, r2.x, r2.width) \
            and oneDCollision(r1.y, r1.height, r2.y, r2.height)

class Item
    constructor: (@x = 0, @y = 0, @width = 32, @height = 32) ->
        @htmlElem = $ '<div>'
        @htmlElem.css 'position', 'absolute'
        @htmlElem.css 'left', @x
        @htmlElem.css 'top', @y
        @htmlElem.css 'width', @width
        @htmlElem.css 'height', @height
        @setTexture('graphics.png')
        @animations =
            nothing: [0, 0, @width, @height, 1, 10]
        @setAnimationName('nothing')

    setPosition: (@x, @y) ->
        @htmlElem.css 'left', @x
        @htmlElem.css 'top', @y

    setTexture: (@textureName) ->
        @htmlElem.css 'background-image', "url(#{@textureName})"
        @setTexturePos(0, 0)
    
    setTexturePos: (@textureX, @textureY) ->
        @htmlElem.css 'background-position', "#{-@textureX}px #{-@textureY}px"

    setAnimation: (@animationStartX, @animationStartY, @animationSteps, @animationSpeed = 1) ->
        @animationCurrentStep = -1

    setAnimationSet: (@animations) ->

    setAnimationName: (@animationName) ->
        animation = @animations[@animationName]
        console.log @animations if not animation
        return if not animation
        @width = animation[2]
        @height = animation[3]
        @setAnimation(animation[0], animation[1], animation[4], animation[5])
    
    nextFrame: (engine) ->
        @animationCurrentStep = (@animationCurrentStep + 1)                 \
                              % (@animationSteps * @animationSpeed)
        @setTexturePos  @animationStartX +                                  \
             Math.floor(@animationCurrentStep / @animationSpeed) * @width,  \
                        @animationStartY

class MovableItem extends Item
    constructor: ->
        super()
        @velocityX = 0
        @velocityY = 0
    
    nextFrame: (engine) ->
        super engine
        @setPosition  @x + @velocityX, @y + @velocityY if not @crashing(engine)

    # return:  0 if no collision
    #          1 if x axis collides
    #          2 if y axis collides
    #          3 if both axes collides
    willCollide: (otherItem) ->
        rectX =
            x: @x + @velocityX
            y: @y
            width: @width
            height: @height
        rectY =
            x: @x
            y: @y + @velocityY
            width: @width
            height: @height
        return \
                1 if rectCollision(rectX, otherItem) \
              + 2 if rectCollision(rectY, otherItem)

    crashing: (engine) ->
        for item in engine.staticItems
            return true if @willCollide(item) > 0
        return false

class RescEngine
    constructor: (@fieldid, @width, @height) ->
        @field = $ @fieldid
        @field.css 'position', 'relative'
        @field.css 'width', @width + 'px'
        @field.css 'height', @height + 'px'
        @field.css 'border', 'solid black 1px'
        @field.css 'display', 'block'
        @field.css 'overflow', 'hidden'

        @staticItems = []
        @allItems = []

    addStaticItem: (item) ->
        @staticItems.push(item)
        @allItems.push(item)
        @field.append(item.htmlElem)

    addItem: (item) ->
        @allItems.push(item)
        @field.append(item.htmlElem)

    nextFrame: ->
        item.nextFrame(this) for item in @allItems

item = null
item2 = null
item3 = null
item4 = null
$(document).ready ->
    engine = new RescEngine '#gamefield', 800, 600
    item = new MovableItem
    item2 = new Item 100, 100
    item3 = new Item 64, 64
    item4 = new Item 555, 190
    engine.addItem item
    engine.addStaticItem item2
    engine.addStaticItem item3
    engine.addStaticItem item4

    item2.setTexturePos 32, 0
    item3.setTexturePos 64, 0
    item4.setTexturePos 94, 0

    item.setAnimationSet animations.hero
    item.setAnimationName 'walk'
    item.velocityX = 2
    item.velocityY = 1

    interval = window.setInterval 'engine.nextFrame()', 33

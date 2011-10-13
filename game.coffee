class Item
    constructor: (@x = 0, @y = 0, @width = 32, @height = 32) ->
        @htmlElem = $ '<div>'
        @htmlElem.css 'background-color', 'yellow'
        @htmlElem.css 'position', 'relative'
        @htmlElem.css 'left', @x
        @htmlElem.css 'top', @y
        @htmlElem.css 'width', @width
        @htmlElem.css 'height', @height

    setPosition: (@x, @y) ->
        @htmlElem.css 'left', @x
        @htmlElem.css 'top', @y


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

$(document).ready ->
    engine = new RescEngine '#gamefield', 800, 600
    item = new Item
    engine.addStaticItem item
    item.setPosition 30, 30

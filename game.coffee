class RescEngine
    constructor: (@fieldid, @width, @height) ->
        @field = $ @fieldid
        @field.css 'width', @width + 'px'
        @field.css 'height', @height + 'px'
        @field.css 'border', 'solid black 1px'
        @field.css 'display', 'block'
        e = $ '<div>'
        e.css 'background-color', 'yellow'
        e.css 'position', 'absolute'
        e.css 'left', '300px'
        e.css 'top', '300px'
        e.css 'width', '64px'
        e.css 'height', '64px'
        @field.append(e)

$(document).ready ->
    engine = new RescEngine '#gamefield', 800, 600

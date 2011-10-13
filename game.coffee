class RescEngine
    constructor: (@fieldid, @width, @height) ->
        @field = $ @fieldid
        @field.css 'width', @width + 'px'
        @field.css 'height', @height + 'px'
        @field.css 'border', 'solid black 1px'
        @field.css 'display', 'block'
        @field.css 'overflow', 'hidden'
        e = $ '<div>'
        e.css 'background-color', 'yellow'
        e.css 'position', 'relative'
        e.css 'left', '790px'
        e.css 'top', '300px'
        e.css 'width', '64px'
        e.css 'height', '64px'
        @field.append(e)

$(document).ready ->
    engine = new RescEngine '#gamefield', 800, 600

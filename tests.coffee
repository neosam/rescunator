$(document).ready ->
    test 'Testing testing engine', ->
        ok true, 'This test always must be good'
        same 1 + 1, 2, 'This should also be good'

    test '1D Collusion detection', ->
        same oneDCollision(1, 4, 6, 3), false, 'Should not collide'
        same oneDCollision(1, 4, 2, 5), true, 'Should collide'
        same oneDCollision(2, 5, 1, 4), true, 'Should also collide'
        same oneDCollision(6, 3, 1, 4), false, 'And this not...'

    test 'Testing rectangular collision detection', ->
        rect1 =
            x: 20
            y: 20
            width: 20
            height: 30
        rect2 =
            x: 0
            y: 0
            width: 15
            height: 10
        same rectCollision(rect1, rect2), false, 'Rects should not collide'
        rect2.width = 21
        same rectCollision(rect1, rect2), false, \
                                            'Rects should not collide again'
        rect2.height = 30
        same rectCollision(rect1, rect2), true, 'Now they should collide'

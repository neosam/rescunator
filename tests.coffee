$(document).ready ->
    test 'Testing testing engine', ->
        ok true, 'This test always must be good'
        same 1 + 1, 2, 'This should also be good'

$(document).ready(function() {
  test('Testing testing engine', function() {
    ok(true, 'This test always must be good');
    return same(1 + 1, 2, 'This should also be good');
  });
  test('1D Collusion detection', function() {
    same(oneDCollision(1, 4, 6, 3), false, 'Should not collide');
    same(oneDCollision(1, 4, 2, 5), true, 'Should collide');
    same(oneDCollision(2, 5, 1, 4), true, 'Should also collide');
    return same(oneDCollision(6, 3, 1, 4), false, 'And this not...');
  });
  return test('Testing rectangular collision detection', function() {
    var rect1, rect2;
    rect1 = {
      x: 20,
      y: 20,
      width: 20,
      height: 30
    };
    rect2 = {
      x: 0,
      y: 0,
      width: 15,
      height: 10
    };
    same(rectCollision(rect1, rect2), false, 'Rects should not collide');
    rect2.width = 21;
    same(rectCollision(rect1, rect2), false, 'Rects should not collide again');
    rect2.height = 30;
    return same(rectCollision(rect1, rect2), true, 'Now they should collide');
  });
});
var Item, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_UP, MovableItem, Player, RescEngine, engine, item, item2, item3, item4, oneDCollision, rectCollision;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
engine = null;
KEY_UP = 38;
KEY_DOWN = 40;
KEY_LEFT = 37;
KEY_RIGHT = 39;
oneDCollision = function(p1, w1, p2, w2) {
  var d1, d2, size;
  size = w1 + w2;
  d1 = p2 + w2 - p1;
  d2 = p1 + w1 - p2;
  if ((0 < d1 && d1 < size) || (0 < d2 && d2 < size)) {
    return true;
  }
  return false;
};
rectCollision = function(r1, r2) {
  return oneDCollision(r1.x, r1.width, r2.x, r2.width) && oneDCollision(r1.y, r1.height, r2.y, r2.height);
};
Item = (function() {
  function Item(x, y, width, height) {
    this.x = x != null ? x : 0;
    this.y = y != null ? y : 0;
    this.width = width != null ? width : 32;
    this.height = height != null ? height : 32;
    this.htmlElem = $('<div>');
    this.htmlElem.css('position', 'absolute');
    this.htmlElem.css('left', this.x);
    this.htmlElem.css('top', this.y);
    this.htmlElem.css('width', this.width);
    this.htmlElem.css('height', this.height);
    this.setTexture('graphics.png');
    this.animations = {
      nothing: [0, 0, this.width, this.height, 1, 10]
    };
    this.setAnimationName('nothing');
  }
  Item.prototype.setPosition = function(x, y) {
    this.x = x;
    this.y = y;
    this.htmlElem.css('left', this.x);
    return this.htmlElem.css('top', this.y);
  };
  Item.prototype.setTexture = function(textureName) {
    this.textureName = textureName;
    this.htmlElem.css('background-image', "url(" + this.textureName + ")");
    return this.setTexturePos(0, 0);
  };
  Item.prototype.setTexturePos = function(textureX, textureY) {
    this.textureX = textureX;
    this.textureY = textureY;
    return this.htmlElem.css('background-position', "" + (-this.textureX) + "px " + (-this.textureY) + "px");
  };
  Item.prototype.setAnimation = function(animationStartX, animationStartY, animationSteps, animationSpeed) {
    this.animationStartX = animationStartX;
    this.animationStartY = animationStartY;
    this.animationSteps = animationSteps;
    this.animationSpeed = animationSpeed != null ? animationSpeed : 1;
    return this.animationCurrentStep = -1;
  };
  Item.prototype.setAnimationSet = function(animations) {
    this.animations = animations;
  };
  Item.prototype.setAnimationName = function(animationName) {
    var animation;
    this.animationName = animationName;
    animation = this.animations[this.animationName];
    if (!animation) {
      console.log(this.animations);
    }
    if (!animation) {
      return;
    }
    this.width = animation[2];
    this.height = animation[3];
    return this.setAnimation(animation[0], animation[1], animation[4], animation[5]);
  };
  Item.prototype.nextFrame = function(engine) {
    this.animationCurrentStep = (this.animationCurrentStep + 1) % (this.animationSteps * this.animationSpeed);
    return this.setTexturePos(this.animationStartX + Math.floor(this.animationCurrentStep / this.animationSpeed) * this.width, this.animationStartY);
  };
  return Item;
})();
MovableItem = (function() {
  __extends(MovableItem, Item);
  function MovableItem() {
    MovableItem.__super__.constructor.call(this);
    this.velocityX = 0;
    this.velocityY = 0;
  }
  MovableItem.prototype.nextFrame = function(engine) {
    MovableItem.__super__.nextFrame.call(this, engine);
    if (!this.crashing(engine)) {
      return this.setPosition(this.x + this.velocityX, this.y + this.velocityY);
    }
  };
  MovableItem.prototype.willCollide = function(otherItem) {
    var rectX, rectY;
    rectX = {
      x: this.x + this.velocityX,
      y: this.y,
      width: this.width,
      height: this.height
    };
    rectY = {
      x: this.x,
      y: this.y + this.velocityY,
      width: this.width,
      height: this.height
    };
    if (rectCollision(rectY, otherItem) ? rectCollision(rectX, otherItem) + 2 : void 0) {
      return 1;
    }
  };
  MovableItem.prototype.crashing = function(engine) {
    var item, _i, _len, _ref;
    _ref = engine.staticItems;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      if (this.willCollide(item) > 0) {
        return true;
      }
    }
    return false;
  };
  return MovableItem;
})();
Player = (function() {
  __extends(Player, MovableItem);
  function Player(engine) {
    var player;
    Player.__super__.constructor.call(this);
    this.defaultSpeedX = 4;
    this.defaultSpeedY = 4;
    player = this;
    $(window).keypress(function(event) {
      switch (event.keyCode) {
        case KEY_UP:
          player.velocityY = -player.defaultSpeedY;
          break;
        case KEY_DOWN:
          player.velocityY = player.defaultSpeedY;
          break;
        case KEY_LEFT:
          player.velocityX = -player.defaultSpeedX;
          break;
        case KEY_RIGHT:
          player.velocityX = player.defaultSpeedX;
      }
      return false;
    });
    $(window).keyup(function(event) {
      console.log("keyup " + event.keyCode);
      switch (event.keyCode) {
        case KEY_UP:
        case KEY_DOWN:
          player.velocityY = 0;
          break;
        case KEY_LEFT:
        case KEY_RIGHT:
          player.velocityX = 0;
      }
      return false;
    });
  }
  return Player;
})();
RescEngine = (function() {
  function RescEngine(fieldid, width, height) {
    this.fieldid = fieldid;
    this.width = width;
    this.height = height;
    this.field = $(this.fieldid);
    this.field.css('position', 'relative');
    this.field.css('width', this.width + 'px');
    this.field.css('height', this.height + 'px');
    this.field.css('border', 'solid black 1px');
    this.field.css('display', 'block');
    this.field.css('overflow', 'hidden');
    this.staticItems = [];
    this.allItems = [];
  }
  RescEngine.prototype.addStaticItem = function(item) {
    this.staticItems.push(item);
    this.allItems.push(item);
    return this.field.append(item.htmlElem);
  };
  RescEngine.prototype.addItem = function(item) {
    this.allItems.push(item);
    return this.field.append(item.htmlElem);
  };
  RescEngine.prototype.nextFrame = function() {
    var item, _i, _len, _ref, _results;
    _ref = this.allItems;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      _results.push(item.nextFrame(this));
    }
    return _results;
  };
  return RescEngine;
})();
item = null;
item2 = null;
item3 = null;
item4 = null;
$(document).ready(function() {
  var interval;
  engine = new RescEngine('#gamefield', 800, 600);
  item = new Player(engine);
  item2 = new Item(100, 100);
  item3 = new Item(64, 64);
  item4 = new Item(555, 190);
  engine.addItem(item);
  engine.addStaticItem(item2);
  engine.addStaticItem(item3);
  engine.addStaticItem(item4);
  item2.setTexturePos(32, 0);
  item3.setTexturePos(64, 0);
  item4.setTexturePos(94, 0);
  item.setAnimationSet(animations.hero);
  item.setAnimationName('walk');
  item.velocityX = 2;
  item.velocityY = 1;
  return interval = window.setInterval('engine.nextFrame()', 33);
});
//
//  TowerMenu.m
//  FoodWar
//
//  Created by Glenn Contreras on 3/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TowerMenu.h"
#import "Util.h"

#define MAX_TOWER_ITEMS 4
#define TOWER_BUTTON_OFFSET 20

@implementation TowerMenu {
    NSArray* _towerClick;
    NSArray* _towerImages;
    NSArray *_towerPrices;
    NSMutableArray* _towerButtons;
    GameScene* _gameScene;
    CCButton* _sellButton;
    CCNodeColor* _sellNode;
}

@synthesize  currTower = _currTower;
@synthesize isShowing = _isShowing;
@synthesize isSellButtonShowing = _isSellButtonShowing;

+ (id)menuWithGameScene:(GameScene*)gameScene {
    return [[self alloc] initWithGameScene:gameScene];
}

- (id)initWithGameScene:(GameScene*)gameScene {
    _towerImages = [NSArray arrayWithObjects:
               @"Assets/ketchup.png",
               @"Assets/mustard.png",
               @"Assets/salt.png",
               @"Assets/pepper.png", nil];
    _towerClick = [NSArray arrayWithObjects:
                   @"Assets/ketchupButton.png",
                   @"Assets/mustardButton.png",
                   @"Assets/saltButton.png",
                   @"Assets/pepperButton.png", nil];
    _towerPrices = [NSArray arrayWithObjects:
                    [NSNumber numberWithInt:300],
                    [NSNumber numberWithInt:400],
                    [NSNumber numberWithInt:500],
                    [NSNumber numberWithInt:600], nil];
    _towerButtons = [NSMutableArray array];
    for (NSString* imageName in _towerClick) {
        CCSprite* towerButton = [CCSprite spriteWithImageNamed:imageName];
        [_towerButtons addObject:towerButton];
    }
    _gameScene = gameScene;
    _sellButton = nil;
    _isShowing = NO;
    _isSellButtonShowing = YES;
    _currTower = nil;
    
    return self;
}

- (BOOL)validTouchInMenu:(CGPoint)loc {
    for (int i = 0; i <_towerButtons.count; i++) {
        CCSprite* t = [_towerButtons objectAtIndex:i];
        if ([Util isTouchInCircle:loc spaceLoc:t.positionInPoints radius:t.contentSizeInPoints.width/2] && [_gameScene getGold] >= [[_towerPrices objectAtIndex:i] integerValue]) {
            [_currTower setTowerSpriteWithImageName:[_towerImages objectAtIndex:i] andType:i];
            [_gameScene buyTowerWithPrice:[_towerPrices objectAtIndex:i]];
            return true;
        }
    }
    return false;
}

- (void)showMenu {
    if (_currTower == nil) return;
    if ([_currTower getTowerSprite] != nil && !_isShowing) {
        _sellButton = [CCButton buttonWithTitle:@"[ sell ]"];
        [_sellButton setPosition:ccp([_currTower getTowerSprite].positionInPoints.x, [_currTower getTowerSprite].positionInPoints.y+35)];
        [_sellButton setTarget:self selector:@selector(sellTower)];
        _sellNode = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(38, 134, 102, 255)] width:50.0f height:27.0f];
        _sellNode.anchorPoint = _sellButton.anchorPoint;
        _sellNode.positionInPoints = _sellButton.positionInPoints;
        [_gameScene addChild:_sellNode];
        [_gameScene addChild:_sellButton];
        _isSellButtonShowing = YES;
        return;
    }
    
    [self loadTowerMenu];
    
    if (_isShowing) return;
    for (CCSprite* towerButton in _towerButtons) {
        [_gameScene addChild:towerButton];
    }
    _isShowing = YES;
}

- (void)hideMenu {
    if (!_isShowing) return;
    
    for (CCSprite* towerButton in _towerButtons) {
        [_gameScene removeChild:towerButton];
    }
    _isShowing = NO;
}

- (void)sellTower {
    [self removeSellButton];
    [_currTower removeTower];
    int price = (int)[[_towerPrices objectAtIndex:[_currTower getTowerType]] integerValue] - 100;
    [_gameScene awardGold:price];
}

- (void)removeSellButton {
    [_gameScene removeChild:_sellNode];
    [_gameScene removeChild:_sellButton];
    _sellButton = nil;
    _sellNode = nil;
    _isSellButtonShowing = NO;
}

- (void)loadTowerMenu {
    CCSprite* baseSprite = [_currTower getBaseSprite];
    CGPoint baseLoc = baseSprite.positionInPoints;
    CGSize baseSize = baseSprite.contentSizeInPoints;
    CGPoint startLoc = ccp(baseLoc.x, baseLoc.y+baseSize.height);
    float offset = baseSize.width/2+TOWER_BUTTON_OFFSET;
    
    if (baseLoc.x > _gameScene.contentSizeInPoints.width/2)
        offset = -offset;
    
    for (int i = 0; i < _towerButtons.count; i++) {
        CCSprite* towerButton = [_towerButtons objectAtIndex:i];
        [towerButton setPositionInPoints:ccp(startLoc.x+(i*offset), startLoc.y)];
    }
}

@end

//
//  Tower.h
//  FoodWar
//
//  Created by Glenn Contreras on 3/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
#import "cocos2d.h"
#import "GameScene.h"

@class GameScene, Enemy;

@interface Tower: CCNode 

+ (id)towerWithGame:(GameScene*)game position:(CGPoint)pos;
- (id)initWithGame:(GameScene*)game position:(CGPoint)pos;
- (CCSprite*)getTowerSprite;
- (CCSprite*)getBaseSprite;
- (void)targetKilled;
- (void)setTowerSpriteWithImageName:(NSString*)towerImage andType:(int)type;
- (void)updateTower;
- (void)removeTower;
- (int)getTowerType;

@end

//
//  Enemy.h
//  FoodWar
//
//  Created by Glenn Contreras on 3/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "cocos2d.h"
#import "GameScene.h"
#import "Tower.h"
#import "Waypoint.h" 

@interface Enemy: CCNode

@property (strong, nonatomic) CCSprite* mySprite;

+ (id)nodeWithGame:(GameScene*)game;
- (id)initWithGame:(GameScene*)game;
- (void)getAttacked:(Tower*)attacker;
- (void)gotLostSight:(Tower*)attacker;
- (void)getDamaged:(int)damage;
- (void)doActivate;
- (void)getRemoved;
- (void)updateEnemy;

@end

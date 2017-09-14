//
//  WayPoint.h
//  FoodWar
//
//  Created by Glenn Contreras on 3/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "cocos2d.h"
#import "GameScene.h"

@interface Waypoint : CCNode

@property (nonatomic,assign) CGPoint myPosition;
@property (nonatomic,weak) Waypoint *nextWaypoint;

+ (id)waypointWithGame:(GameScene*)game location:(CGPoint)loc;
- (id)initWithGame:(GameScene*)game location:(CGPoint)loc;

@end

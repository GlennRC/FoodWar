//
//  WayPoint.m
//  FoodWar
//
//  Created by Glenn Contreras on 3/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Waypoint.h"

@implementation Waypoint

@synthesize myPosition;
@synthesize nextWaypoint;

+ (id)waypointWithGame:(GameScene*)game location:(CGPoint)loc {
    return [[self alloc] initWithGame:game location:loc];
}

- (id)initWithGame:(GameScene*)game location:(CGPoint)loc {
    if( (self=[super init])) {
        
        [self setPosition:CGPointZero];
        myPosition = loc;
        [game addChild:self];
        
    }
    return self;
}

@end

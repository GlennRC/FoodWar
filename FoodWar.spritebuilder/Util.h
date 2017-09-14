//
//  Util.h
//  FoodWar
//
//  Created by Glenn Contreras on 3/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (float)frandFloatBetween:(float)low and:(float)high;
+ (int)randFloatBetween:(int)low and:(int)high;
+ (CGPoint)randomizePosWithRelativePos:(CGPoint)pos andSize:(CGSize)size;
+ (BOOL)isTouchInTileWithTouch:(CGPoint*)touchLoc andTile:(CGRect*)tile;
+ (BOOL)isTouchInCircle:(CGPoint)touchLoc spaceLoc:(CGPoint)spaceLoc radius:(float)rad;
+ (int)indexFromTowerSpace:(CGPoint)touchLoc towerButtonsLoc:(CGPoint)tmLoc MenuRect:(CGRect)tmRect;
+ (BOOL)circle:(CGPoint)circlePoint withRadius:(float)radius collisionWithCircle:(CGPoint)circlePointTwo collisionCircleRadius:(float)radiusTwo;
+ (BOOL)isPosition:(CGPoint)pos inScreen:(CGSize)screen;

@end

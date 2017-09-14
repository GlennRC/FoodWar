//
//  Util.m
//  FoodWar
//
//  Created by Glenn Contreras on 3/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (BOOL)isTouchInTileWithTouch:(CGPoint*)touchLoc andTile:(CGRect*)tile {
    CCLOG(@"Utile method not implemented");
    return false;
}

+ (BOOL)isTouchInCircle:(CGPoint)touchLoc spaceLoc:(CGPoint)spaceLoc radius:(float)rad {
    float diffX = fabs(touchLoc.x - spaceLoc.x);
    float diffY = fabs(touchLoc.y - spaceLoc.y);
    
    float euclidDist = sqrtf((diffX*diffX) + (diffY*diffY));
    
    if (euclidDist < rad) return true;
    return false;
}

+ (int)indexFromTowerSpace:(CGPoint)touchLoc towerButtonsLoc:(CGPoint)tmLoc MenuRect:(CGRect)tmRect {
    
    if (touchLoc.x < (tmLoc.x+(tmRect.size.width/2)) && touchLoc.y > (tmLoc.y+(tmRect.size.height/2))) {
        return 0;
    }
    if (touchLoc.x > (tmLoc.x+(tmRect.size.width/2)) && touchLoc.y > (tmLoc.y+(tmRect.size.height/2))) {
        return 1;
    }
    if (touchLoc.x < (tmLoc.x+(tmRect.size.width/2)) && touchLoc.y < (tmLoc.y+(tmRect.size.height/2))) {
        return 2;
    }
    if (touchLoc.x > (tmLoc.x+(tmRect.size.width/2)) && touchLoc.y > (tmLoc.y+(tmRect.size.height/2))) {
        return 3;
    }
    CCLOG(@"No Case");
    return -1;
}

+ (BOOL)circle:(CGPoint)circlePoint withRadius:(float)radius collisionWithCircle:(CGPoint)circlePointTwo collisionCircleRadius:(float)radiusTwo {
    float xdif = circlePoint.x - circlePointTwo.x;
    float ydif = circlePoint.y - circlePointTwo.y;
    
    float distance = sqrt(xdif*xdif+ydif*ydif);
    
    if(distance <= radius+radiusTwo)
        return YES;
    
    return NO;
}

+ (float)frandFloatBetween:(float)low and:(float)high {
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}

+ (int)randFloatBetween:(int)low and:(int)high {
    int diff = high - low;
    return (((int) rand() / RAND_MAX) * diff) + low;
}

+ (CGPoint)randomizePosWithRelativePos:(CGPoint)pos andSize:(CGSize)size {
    
    float high = pos.y - size.height/2;
    float low = pos.y + size.height/2;
    float randPosY = [self randFloatBetween:low and:high];
    
    return ccp(pos.x, randPosY);
    
}

+ (BOOL)isPosition:(CGPoint)pos inScreen:(CGSize)screen {
    if (pos.x > 0 && pos.x < screen.width && pos.y > 0 && pos.y < screen.height) {
        return true;
    }
    return false;
}

@end

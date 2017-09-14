//
//  MenuScene.m
//  FoodWar
//
//  Created by Glenn Contreras on 3/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MenuScene.h"

@implementation MenuScene {
    CCNodeColor* colorNode;
}

-(void)didLoadFromCCB {
    colorNode = nil;
    self.userInteractionEnabled = true;
}

-(void)playGame {
    CCScene* gamePlayScene = [CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:gamePlayScene withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

- (void)showInstructions {
    
    CCLOG(@"show instructions");
    
    NSString *instruction = @"                          Background Story: \n"
                            @"  All the Food are ANGRY!\n"
                            @"  They feel sauceless, unflavorful, and not delicious\n"
                            @"  And they plan to ruin your picnic\n"
                            @"  If you don't do something!\n"
                            @"  Help saucify the Bad Food with\n"
                            @"  Ketchup, Mustard, Salt, and Pepper\n"
                            @"  So they can be HAPPY and TASTY!\n\n"
                            @"                             Instructions: \n"
                            @" Buying a sauce - Click on an empty plate \n"
                            @"                - Click on the sauce you want for 300 gold\n"
                            @" Selling a sauce - Click on the sauce you want to sell \n"
                            @"                 - Click on the 'Sell' button gain 200 gold\n\n"
                            @"                  Press anywhere to Continue";
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:instruction fontName:@"ArialMT" fontSize:15];
    label.contentSize = self.contentSize;
    
    colorNode = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(200, 134, 90, 255)] width:400.0f height:295.0f];
    [colorNode setPositionInPoints:ccp(90, 10)];
    [label setPosition:ccp(colorNode.position.x+colorNode.contentSize.width/3.5, colorNode.position.y+colorNode.contentSize.height/2-10)];
    [colorNode addChild:label];
    [self addChild:colorNode];
    
    
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    if (colorNode != nil) {
        [self removeChild:colorNode];
        colorNode = nil;
    }
}

@end

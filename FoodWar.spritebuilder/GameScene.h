//
//  GameScene.h
//  FoodWar
//
//  Created by Glenn Contreras on 3/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "cocos2d.h"
#import <AVFoundation/AVFoundation.h>

@interface GameScene : CCScene <CCTableViewDataSource, AVAudioPlayerDelegate>

@property (strong, nonatomic) NSMutableArray* towers;
@property (strong, nonatomic) NSMutableArray* enemies;
@property (strong, nonatomic) NSMutableArray* waypoints;

- (void)enemyGotKilled;
- (void)getHpDamage;
- (void)doGameOver;
- (void)awardGold:(int)gold;
- (void)buyTowerWithPrice:(NSNumber*)price;
- (int)getGold;

@end

//
//  TowerMenu.h
//  FoodWar
//
//  Created by Glenn Contreras on 3/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "cocos2d.h"
#import "GameScene.h"
#import "Tower.h"

@interface TowerMenu : CCNode

@property (nonatomic, strong) Tower* currTower;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, assign) BOOL isSellButtonShowing;

+ (id)menuWithGameScene:(GameScene*)gameScene;
- (BOOL)validTouchInMenu:(CGPoint)loc;
- (void)removeSellButton;
- (void)showMenu;
- (void)hideMenu;

@end
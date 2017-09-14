//
//  Tower.m
//  FoodWar
//
//  Created by Glenn Contreras on 3/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Tower.h"
#import "Enemy.h"
#import "Util.h"

@implementation Tower {
    int _attackRange;
    int _damage;
    float _fireRate;
    BOOL _attacking;
    NSString* bulletType;
    CCSprite* _myBaseSprite;
    CCSprite* _myTowerSprite;
    Enemy* _chosenEnemy;
    GameScene* _gameScene;
    int _towerType;
}

+ (id) towerWithGame:(GameScene*)game position:(CGPoint)pos{
    return [[self alloc] initWithGame:game position:pos];
}

- (id)initWithGame:(GameScene*)game position:(CGPoint)pos {
    if( (self=[super init])) {
        
        _gameScene = game;
        _towerType = -1;
        _myBaseSprite = [CCSprite spriteWithImageNamed:@"Assets/plate.png"];
        [_myBaseSprite setPositionInPoints:pos];
        [self addChild:_myBaseSprite];
        _attackRange = 70;
        _damage = 10;
        _fireRate = 1;
        _myTowerSprite = nil;
        [self schedule:@selector(updateTower) interval:1.0f/30.0f];
    }
    
    return self;
}
 
- (void)setTowerSpriteWithImageName:(NSString*)towerImage andType:(int)type {
    if ([towerImage  isEqual: @"Assets/ketchup.png"]) {
        _attackRange = 70;
        _damage = 10;
        _fireRate = 1;
        bulletType = @"Assets/ketchupBullet.png";
    }
    else if ([towerImage isEqual: @"Assets/mustard.png"]) {
        _attackRange = 100;
        _damage = 0.8;
        _fireRate = 0.3;
        bulletType = @"Assets/mustardBullet.png";
    }
    else if ([towerImage isEqual: @"Assets/salt.png"]) {
        _attackRange = 100;
        _damage = 30;
        _fireRate = 0.7;
        bulletType = @"Assets/saltBullet.png";
    }
    else if ([towerImage isEqual: @"Assets/pepper.png"]) {
        _attackRange = 70;
        _damage = 70;
        _fireRate = 1.5;
        bulletType = @"Assets/pepperBullet.png";
    }
    
    [self removeTower];
    
    _towerType = type;
    _myTowerSprite = [CCSprite spriteWithImageNamed:towerImage];
    [_myTowerSprite setPositionInPoints:_myBaseSprite.positionInPoints];
    [self addChild:_myTowerSprite];
}

- (CCSprite*)getBaseSprite {
    return _myBaseSprite;
}

- (CCSprite*)getTowerSprite {
    return _myTowerSprite;
}

- (int)getTowerType {
    return _towerType;
}

- (void)removeTower {
    if (_myTowerSprite != nil) {
        [self removeChild:_myTowerSprite];
        _myTowerSprite = nil;
    }
}


- (void)updateTower {
    if (_myTowerSprite == nil) return;
    
    if (_chosenEnemy) {
        //We make it turn to target the enemy chosen
        CGPoint normalized = ccpNormalize(ccp(_chosenEnemy.mySprite.position.x-_myTowerSprite.position.x,_chosenEnemy.mySprite.position.y-_myTowerSprite.position.y));
        _myTowerSprite.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y,-normalized.x))+90;
        
        if (![Util circle:_myTowerSprite.position withRadius:_attackRange collisionWithCircle:_chosenEnemy.mySprite.position collisionCircleRadius:1])
            [self lostSightOfEnemy];
    }
    else {
        for(Enemy* enemy in _gameScene.enemies) {
            if ([Util circle:_myTowerSprite.position withRadius:_attackRange collisionWithCircle:enemy.mySprite.position collisionCircleRadius:1] && [Util isPosition:enemy.mySprite.position inScreen:_gameScene.contentSizeInPoints]) {
                [self chosenEnemyForAttack:enemy];
                break;
            }
        }
    }
    
}

- (void)attackEnemy {
    [self schedule:@selector(shootWeapon) interval:_fireRate];
}

- (void)chosenEnemyForAttack:(Enemy *)enemy {
    _chosenEnemy = nil;
    _chosenEnemy = enemy;
    [self attackEnemy];
    [enemy getAttacked:self];
}


- (void)shootWeapon {
    CCSprite* bullet = [CCSprite spriteWithImageNamed:bulletType];
    [_gameScene addChild:bullet];
    [bullet setPosition:_myTowerSprite.position];
    [bullet runAction:[CCActionSequence actions:
                       [CCActionMoveTo actionWithDuration:0.1 position:_chosenEnemy.mySprite.position],
                       [CCActionCallFunc actionWithTarget:self selector:@selector(damageEnemy)],
                       [CCActionRemove action], nil]];
}

- (void)damageEnemy {
    [_chosenEnemy getDamaged:_damage];
}

- (void)targetKilled {
    if(_chosenEnemy)
        _chosenEnemy =nil;
    
    [self unschedule:@selector(shootWeapon)];
}

- (void)lostSightOfEnemy {
    [_chosenEnemy gotLostSight:self];
    if(_chosenEnemy)
        _chosenEnemy =nil;
    
    [self unschedule:@selector(shootWeapon)];
}

@end

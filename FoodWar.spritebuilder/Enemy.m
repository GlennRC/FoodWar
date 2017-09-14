//
//  Enemy.m
//  FoodWar
//
//  Created by Glenn Contreras on 3/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Enemy.h"
#import "Util.h"

#define HEALTH_BAR_WIDTH 20
#define HEALTH_BAR_ORIGIN -10

@implementation Enemy {
    int _maxHp;
    int _currentHp;
    float _walkingSpeed;
    BOOL _active;
    NSString* randomEnemy;
    CGPoint _myPosition;
    NSMutableArray* _attackedBy;
    
    Waypoint* _destinationWaypoint;
    GameScene* _game;
}

@synthesize mySprite = _mySprite;

+ (id)nodeWithGame:(GameScene*)game {
    return [[self alloc] initWithGame:game];
}

-(id)initWithGame:(GameScene*)game {
    if ((self=[super init])) {
        
        _game = game;
        _maxHp = 40;
        _currentHp = _maxHp;
        
        _active = NO;
        
        _walkingSpeed = 0.5;
        
        _mySprite = [CCSprite spriteWithImageNamed:@"Assets/fries.png"];
        [self randomlyGenerateEnemy];
        [self setEnemySpriteWithImageName:randomEnemy];
        [self addChild:_mySprite];
        
        Waypoint* waypoint = [game.waypoints objectAtIndex:[game.waypoints count]-1];
        
        _destinationWaypoint = waypoint.nextWaypoint;
        
        _myPosition = waypoint.myPosition;
        
        _attackedBy = [NSMutableArray array];
        
        [_mySprite setPosition:_myPosition];
        
        [self schedule:@selector(updateEnemy) interval:1.0f/30.0f];
    }
    
    return self;
}

-(void)randomlyGenerateEnemy {
    NSUInteger v = arc4random_uniform(11);
    switch (v) {
        case 0:
             _mySprite = [CCSprite spriteWithImageNamed:@"Assets/fries.png"];
            randomEnemy = @"Assets/fries.png";
            break;
        case 1:
            _mySprite = [CCSprite spriteWithImageNamed:@"Assets/popcorn.png"];
            randomEnemy = @"Assets/popcorn.png";
            break;
        case 2:
            _mySprite = [CCSprite spriteWithImageNamed:@"Assets/doughnut.png"];
            randomEnemy = @"Assets/doughnut.png";
            break;
        case 3:
            _mySprite = [CCSprite spriteWithImageNamed:@"Assets/asparagus.png"];
            randomEnemy = @"Assets/asparagus.png";
            break;
        case 4:
            _mySprite = [CCSprite spriteWithImageNamed:@"Assets/eggplant.png"];
            randomEnemy = @"Assets/eggplant.png";
            break;
        case 5:
            _mySprite = [CCSprite spriteWithImageNamed:@"Assets/garlic.png"];
            randomEnemy = @"Assets/garlic.png";
            break;
        case 6:
            _mySprite = [CCSprite spriteWithImageNamed:@"Assets/lemon.png"];
            randomEnemy = @"Assets/lemon.png";
            break;
        case 7:
            _mySprite = [CCSprite spriteWithImageNamed:@"Assets/juice.png"];
            randomEnemy = @"Assets/juice.png";
            break;
        case 8:
            _mySprite = [CCSprite spriteWithImageNamed:@"Assets/kiwi.png"];
            randomEnemy = @"Assets/kiwi.png";
            break;
        case 9:
            _mySprite = [CCSprite spriteWithImageNamed:@"Assets/melonslice.png"];
            randomEnemy = @"Assets/melonslice.png";
            break;
        case 10:
            _mySprite = [CCSprite spriteWithImageNamed:@"Assets/pretzel.png"];
            randomEnemy = @"Assets/pretzel.png";
            break;
            
        default:
            break;
    }
}

- (void)setEnemySpriteWithImageName:(NSString*)EnemyImage {
    if ([EnemyImage  isEqual: @"Assets/fries.png"]) {
        _walkingSpeed = 1.4;
        _maxHp = 70;
    }
    else if ([EnemyImage isEqual: @"Assets/popcorn.png"]) {
        _walkingSpeed = 0.6;
        _maxHp = 250;
    }
    else if ([EnemyImage isEqual: @"Assets/doughnut.png"]) {
        _walkingSpeed = 2;
        _maxHp = 30;
    }
    else if ([EnemyImage isEqual: @"Assets/asparagus.png"]) {
        _walkingSpeed = 1;
        _maxHp = 100;
    }
    else if ([EnemyImage isEqual: @"Assets/eggplant.png"]) {
        _walkingSpeed = 1.1;
        _maxHp = 10;
    }
    else if ([EnemyImage isEqual: @"Assets/garlic.png"]) {
        _walkingSpeed = 0.9;
        _maxHp = 10;
    }
    else if ([EnemyImage isEqual: @"Assets/lemon.png"]) {
        _walkingSpeed = 1.3;
        _maxHp = 80;
    }
    else if ([EnemyImage isEqual: @"Assets/juice.png"]) {
        _walkingSpeed = 0.8;
        _maxHp = 120;
    }
    else if ([EnemyImage isEqual: @"Assets/kiwi.png"]) {
        _walkingSpeed = 1.3;
        _maxHp = 150;
    }
    else if ([EnemyImage isEqual: @"Assets/melonslice.png"]) {
        _walkingSpeed = 1.7;
        _maxHp =50;
    }
    else if ([EnemyImage isEqual: @"Assets/pretzel.png"]) {
        _walkingSpeed = 1.5;
        _maxHp = 60;
    }
}

- (void)doActivate{
    _active = YES;
}


- (void)updateEnemy {
    if(!_active) return;
    
    if([Util circle:_myPosition withRadius:1 collisionWithCircle:_destinationWaypoint.myPosition collisionCircleRadius:1]) {
        if(_destinationWaypoint.nextWaypoint) {
            _destinationWaypoint = _destinationWaypoint.nextWaypoint;
        }
        else {
            //Reached the end of the road. Damage the player
            [_game getHpDamage];
            [self getRemoved];
        }
    }
    
    CGPoint targetPoint = _destinationWaypoint.myPosition;
    float movementSpeed = _walkingSpeed;
    
    CGPoint normalized = ccpNormalize(ccp(targetPoint.x-_myPosition.x,targetPoint.y-_myPosition.y));
    _mySprite.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y,-normalized.x));
    
    _myPosition = ccp(_myPosition.x + (normalized.x*movementSpeed),_myPosition.y + (normalized.y*movementSpeed));
    
    [_mySprite setPosition:_myPosition];
}

-(void)getRemoved {
    
    for(Tower * attacker in _attackedBy) {
        [attacker targetKilled];
    }
    [_game.enemies removeObject:self];
    [_game enemyGotKilled];
    [_game removeChild:self];
}

-(void)getAttacked:(Tower *)attacker {
    [_attackedBy addObject:attacker];
}

-(void)gotLostSight:(Tower *)attacker {
    [_attackedBy removeObject:attacker];
}

-(void)getDamaged:(int)damage {
    _currentHp -=damage;
    if(_currentHp <=0) {
        [_game awardGold:200];
        [self getRemoved];
    }
}

@end

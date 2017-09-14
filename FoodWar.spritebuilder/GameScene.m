//
//  GameScene.m
//  FoodWar
//
//  Created by Glenn Contreras on 3/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "Util.h"
#import "TowerMenu.h"
#import "Enemy.h"
#import "Waypoint.h"

@implementation GameScene {
    TowerMenu* _towerMenu;
    int wave;
    int playerHp;
    BOOL gameEnded;
    BOOL _isHelpMenuShowing;
    BOOL _isInstructShowing;
    int playerGold;
    CGPoint helpMenuLoc;
    CCLabelTTF *ui_wave_lbl;
    CCLabelTTF *ui_hp_lbl;
    CCLabelTTF *ui_gold_lbl;
    CCTableView *_helpMenu;
    CCNodeColor* _instructNode;
    NSArray* _instructLabel;
    NSArray* _instructions;
    AVAudioPlayer *_audioPlayer;
}

@synthesize towers = _towers;
@synthesize enemies = _enemies;
@synthesize waypoints = _waypoints;

- (void)didLoadFromCCB {
    
    //Load background music
    NSString *path = [NSString stringWithFormat:@"%@/backgroundAudio.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    NSError* err;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&err];
    
    if(err){
        NSLog(@"Failed with reason: %@", [err localizedDescription]);
    }
    else {
        _audioPlayer.delegate = self;
        [_audioPlayer play];
        _audioPlayer.numberOfLoops = -1;
        _audioPlayer.currentTime = 0;
        _audioPlayer.volume = 1.0;
    }
    
    // Load the background
    CCSprite* background = [CCSprite spriteWithImageNamed:@"Assets/PicnicBack.png"];
    [background setAnchorPoint:self.anchorPointInPoints];
    [background setPositionInPoints:self.positionInPoints];
    [self addChild:background];
    
    // Load the path
    CCSprite* roads = [CCSprite spriteWithImageNamed:@"Assets/Road.png"];
    [roads setAnchorPoint:self.anchorPointInPoints];
    [roads setPositionInPoints:self.positionInPoints];
    [self addChild:roads];
    
    _instructLabel = [NSArray arrayWithObjects:@"Buy a sauce", @"Sell a sauce", @"Back to menu", nil];
    _instructions = [NSArray arrayWithObjects:@"Click on a plate and choose the tower you want.",
                     @"Click on a tower and press the sell button.",nil];
    _helpMenu = nil;
    _instructNode = nil;
    _isHelpMenuShowing = NO;
    _isInstructShowing = NO;
    
    // Enable touch
    self.userInteractionEnabled = true;
    
    // Set the starting unfo
    wave = 0;
    
    // Initialize the tower menu
    _towerMenu = [TowerMenu menuWithGameScene:self];
    
    // Initialize the arrays
    _towers = [NSMutableArray array];
    _enemies = [NSMutableArray array];
    _waypoints = [NSMutableArray array];
    
    // Load the tower bases and display them
    [self loadTowerSpaces];
    
    // Load the waypoints
    [self loadWaypoints];
    
    // Load the first wave
    [self loadWave];
    
    // Load top background
    CCSprite* topBackground = [CCSprite spriteWithImageNamed:@"Assets/topBackground.png"];
    [topBackground setAnchorPoint:ccp(0,1)];
    [topBackground setPositionInPoints:ccp(0,self.contentSizeInPoints.height)];
    [self addChild:topBackground];
    
    // Create wave label
    ui_wave_lbl = [CCLabelTTF labelWithString: [NSString stringWithFormat:@"WAVE: %d", wave] fontName:@"ArialMT" fontSize:20];
    [ui_wave_lbl setPosition:ccp(400,self.contentSizeInPoints.height-12)];
    [ui_wave_lbl setAnchorPoint:ccp(0,0.9)];
    [self addChild:ui_wave_lbl];
    
    // Load player Hp
    playerHp = 5;
    ui_hp_lbl = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"HP: %d",playerHp] fontName:@"ArialMT" fontSize:20];
    [ui_hp_lbl setPosition:ccp(35,self.contentSizeInPoints.height-12)];
    [ui_hp_lbl setAnchorPoint:ccp(0,0.9)];
    [self addChild:ui_hp_lbl];
    
    // Load gold
    playerGold = 1000;
    ui_gold_lbl = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"GOLD: %d",playerGold] fontName:@"ArialMT" fontSize:20];
    [ui_gold_lbl setPosition:ccp(135,self.contentSizeInPoints.height-12)];
    [ui_gold_lbl setAnchorPoint:ccp(0,0.9)];
    [self addChild:ui_gold_lbl];
    
    CCButton *helpButton = [CCButton buttonWithTitle:@"[ Help ]"];
    [helpButton setPosition:ccp(self.contentSizeInPoints.width-40, self.contentSizeInPoints.height-20)];
    helpMenuLoc = helpButton.position;
    [helpButton setTarget:self selector:@selector(showHelpMenu)];
    [self addChild:helpButton];
}

- (void)showHelpMenu {
    if (_isHelpMenuShowing) {
        [self removeChild:_helpMenu];
        _isHelpMenuShowing = NO;
        return;
    }
    _helpMenu = [CCTableView node];
    [_helpMenu setPosition:ccp(helpMenuLoc.x-75, -40)];
    _helpMenu.dataSource = self;
    __weak typeof(self) weakSelf = self;
    __weak typeof(_helpMenu) weakMenu = _helpMenu;
    _helpMenu.block = ^(CCTableView* tableView) {
        [weakSelf menuItemPressed:weakMenu.selectedRow];
    };
    [self addChild:_helpMenu];
    _isHelpMenuShowing = YES;
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    if (_towerMenu.isShowing) {
        if ([_towerMenu validTouchInMenu:touchLoc]) {
            [_towerMenu hideMenu];
            return;
        }
    }
    
    if (_isInstructShowing) {
        [self removeChild:_instructNode];
        _isInstructShowing = NO;
        return;
    }
    
    if (_towerMenu.isSellButtonShowing) {
        [_towerMenu removeSellButton];
        return;
    }
    
    BOOL isTouching = NO;
    // Check if user is touching a valid space
    for (Tower* tower in _towers) {
        CCSprite *t = [tower getBaseSprite];
        if ([Util isTouchInCircle:touchLoc spaceLoc:t.positionInPoints radius:t.contentSizeInPoints.width/2]) {
            _towerMenu.currTower = tower;
            isTouching = YES;
        }
    }
    if (isTouching) [_towerMenu showMenu];
    else [_towerMenu hideMenu];
}

- (void)loadTowerSpaces
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"L1_TowerLoc" ofType:@"plist"];
    NSArray * towerPositions = [NSArray arrayWithContentsOfFile:plistPath];
    
    for(NSDictionary* towerPos in towerPositions) {
        CGPoint pos = ccp([[towerPos objectForKey:@"x"] floatValue], [[towerPos objectForKey:@"y"] floatValue]);
        Tower* tower = [Tower towerWithGame:self position:pos];
        [self addChild:tower];
        [_towers addObject:tower];
    }
}

- (void)loadWaypoints {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"L1_PathVert" ofType:@"plist"];
    NSArray * pathVert = [NSArray arrayWithContentsOfFile:plistPath];
    Waypoint* nextWaypoint = nil;
    
    for (int i = (int)[pathVert count]-1;i>=0; i--) {
        NSDictionary* vert = [pathVert objectAtIndex:i];
        CGPoint loc = CGPointZero;
        loc = ccp([[vert objectForKey:@"x"] floatValue], [[vert objectForKey:@"y"] floatValue]);
        Waypoint* waypoint = [Waypoint waypointWithGame:self location:loc];
        waypoint.nextWaypoint = nextWaypoint;
        nextWaypoint = waypoint;
        [_waypoints addObject:waypoint];
    }
}

- (BOOL)loadWave {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"L1_Waves" ofType:@"plist"];
    NSArray* waveData = [NSArray arrayWithContentsOfFile:plistPath];
    
    if(wave >= [waveData count]) {
        return NO;
    }
    
    NSArray * currentWaveData =[NSArray arrayWithArray:[waveData objectAtIndex:wave]];
    
    for(NSDictionary * enemyData in currentWaveData) {
        Enemy * enemy = [Enemy nodeWithGame:self];
        [enemy scheduleOnce:@selector(doActivate) delay:[[enemyData objectForKey:@"spawnTime"] floatValue]];
        [self addChild:enemy];
        [_enemies addObject:enemy];
    }
    
    wave++;
    [ui_wave_lbl setString:[NSString stringWithFormat:@"WAVE: %d",wave]];
    
    return YES;
}

- (void)enemyGotKilled {
    if ([_enemies count]<=0) {
        if(![self loadWave])
            [self doWin];
    }
}

-(void)getHpDamage {
    playerHp--;
    [ui_hp_lbl setString:[NSString stringWithFormat:@"HP: %d",playerHp]];
    if (playerHp <=0) {
        [self doGameOver];
    }
}

- (void)doWin {
    if (!gameEnded) {
        gameEnded = YES;
        [self showWin];
    }
}

-(void)doGameOver {
    if (!gameEnded) {
        gameEnded = YES;
        [self showGameOver];
    }
}

- (void)showWin {
    CCNodeColor* colorNode = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(38, 134, 102, 255)] width:300.0f height:50.0f];
    colorNode.anchorPoint = ccp(0.5, 0.5);
    [colorNode setPositionInPoints:ccp(self.contentSize.width/2, self.contentSize.height/2)];
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:@"You saved the food!"fontName:@"ArialMT" fontSize:30];
    [label setPosition:ccp(colorNode.contentSize.width/2, colorNode.contentSize.height/2)];
    
    [colorNode addChild:label];
    [self addChild:colorNode];
    
    _audioPlayer = nil;
    
    [self performSelector:@selector(backToMenu) withObject:self afterDelay:3];
}

- (void)showGameOver {
    
    CCNodeColor* colorNode = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(38, 134, 102, 255)] width:250.0f height:50.0f];
    colorNode.anchorPoint = ccp(0.5, 0.5);
    [colorNode setPositionInPoints:ccp(self.contentSize.width/2, self.contentSize.height/2)];
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:@"GAME OVER"fontName:@"ArialMT" fontSize:30];
    [label setPosition:ccp(colorNode.contentSize.width/2, colorNode.contentSize.height/2)];
    
    [colorNode addChild:label];
    [self addChild:colorNode];
    
    _audioPlayer = nil;
    
    [self performSelector:@selector(backToMenu) withObject:self afterDelay:3];
}

- (void)backToMenu {
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MenuScene"] withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:1]];
}

-(void)awardGold:(int)gold {
    playerGold += gold;
    [ui_gold_lbl setString:[NSString stringWithFormat:@"GOLD: %d",playerGold]];
}

- (void)buyTowerWithPrice:(NSNumber *)price {
    playerGold -= [price integerValue];
    [ui_gold_lbl setString:[NSString stringWithFormat:@"GOLD: %d",playerGold]];
}

- (int)getGold {
    return playerGold;
}

- (CCTableViewCell*) tableView:(CCTableView*)tableView nodeForRowAtIndex:(NSUInteger) index {
    CCTableViewCell* cell = [CCTableViewCell node];
    cell.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitUIPoints);
    cell.contentSize = CGSizeMake(1.0f, 32.0f);
    

    CCLabelTTF* label = [CCLabelTTF labelWithString:[_instructLabel objectAtIndex:index]fontName:@"ArialMT" fontSize:15];
    label.contentSize = cell.contentSize;
    
    CCNodeColor* colorNode = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(38, 134, 102, 255)] width:100.0f height:28.0f];
    [label setPosition:ccp(colorNode.position.x+colorNode.contentSize.width/2, colorNode.position.y+colorNode.contentSize.height/2)];
    
    [colorNode addChild:label];
    [cell addChild:colorNode];
    
    return cell;
}

- (NSUInteger) tableViewNumberOfRows:(CCTableView*) tableView {
    return _instructLabel.count;
}

- (void)menuItemPressed:(NSUInteger)index {
    [self removeChild:_helpMenu];
    
    if (index == 2) {
        [self doGameOver];
        return;
    }
    
    _instructNode = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(38, 134, 102, 255)] width:350 height:100];
    _instructNode.anchorPoint = ccp(0.5, 0.5);
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:[_instructions objectAtIndex:index]fontName:@"ArialMT" fontSize:15];
    [label setPosition:ccp(_instructNode.position.x+_instructNode.contentSize.width/2, _instructNode.position.y+_instructNode.contentSize.height/2)];
    
    [_instructNode setPositionInPoints:ccp(self.contentSize.width/2, self.contentSize.height/2)];
    [_instructNode addChild:label];
    [self addChild:_instructNode];
    
    _isInstructShowing = YES;
    _isHelpMenuShowing = NO;
}

@end

//
//  Game.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//

#import "Game.h"
#import "GAIDictionaryBuilder.h"

#define KEY_HIGHT_SCORE @"fl_hight_score"
#define kGAIScreenName @"Scene Name"

static Game *instance = nil;
@implementation Game
@synthesize currentValue, currentScore, highestScore, valueColorMapsDictionary, colorMap, gameState, isFbLoggedIn, facebookUserDetail, tracker;

-(id)init
{
    if(self = [super init]){
        colorMap = @{
                     @0: @0xeae8e4,
                     @1: @0xeae8e4,
                     @2: @0xeae8e4,
                     @4: @0xede0ca,
                     @8: @0xedddba,
                     @16: @0xeddaab,
                     @32: @0xedd79b,
                     @64: @0xedd48b,
                     @128: @0xedd17c,
                     @256: @0xedce6c,
                     @512: @0xedcb5c,
                     @1024: @0xedc84d,
                     @2048: @0xedc53d,
                     };
        
        isFbLoggedIn = false;
        facebookUserDetail = [[NSMutableDictionary alloc] init];
        [[GAI sharedInstance] defaultTracker];
    }
    return self;
}

+(Game*)sharedInstance{
    @synchronized(self){
        if(instance == nil){
            instance = [[Game alloc] init];
        }
        
        return instance;
    }
}
-(void)loadCurrentUserInfo
{
    NSUserDefaults *sharedUserDefault = [NSUserDefaults standardUserDefaults];
    NSInteger highScore = [sharedUserDefault integerForKey:KEY_HIGHT_SCORE];
    highestScore = (long)highScore;
    currentScore = 0;
    currentValue = 1;
    
}
-(void)updateNewUserInfo{
//    @synchronized(self)
    [[NSUserDefaults standardUserDefaults] setInteger:highestScore forKey:KEY_HIGHT_SCORE];
}

-(void)registeGameNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameGotoBackground:) name:NT_GAME_GOTO_BACKGROUND object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameReturnForeground:) name:NT_GAME_RETURN_FOREGROUND object:nil];
    
}
-(void)unregisterGameNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(CCSprite*)loadSpriteFile:(NSString*)imageName{
    CCSprite *sp = [CCSprite spriteWithFile:imageName];
    return  sp;
}
#pragma mark private methods
-(void)generateValueColorMapDictionary
{
    
    CCLOG(@"Did receive game goto background");
}

-(void)gameReturnForeGround:(NSNotification*)noti
{
    
    CCLOG(@"Did receive game return foreground");
}
-(UIColor*)getColorFor:(long)number{
    UIColor *color = [self colorFromHexString:[colorMap objectForKey:[NSString stringWithFormat:@"%ld", number]]];
    return  color;
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark Facebook Implement
-(void)createFbSession{
    FBSession* session = [[FBSession alloc] init];
    [FBSession setActiveSession: session];
}

-(void)openFbSession:(void(^)(bool))callback{
    NSArray *permissions = [[NSArray alloc] initWithObjects: @"email", @"public_profile", @"user_friends",nil];
    // Attempt to open the session. If the session is not open, show the user the Facebook login UX
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:false
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        // Did something go wrong during login? I.e. did the user cancel?
        if (status == FBSessionStateClosedLoginFailed || status == FBSessionStateClosed || status == FBSessionStateCreatedOpening) {
            isFbLoggedIn = false;
            callback(false);
        }
        else {
            isFbLoggedIn = true;
            callback(true);
        }
    }];
}


-(void)login:(void (^)(bool))callback{
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email", @"public_profile", @"user_friends",
                            nil];
    // Attempt to open the session. If the session is not open, show the user the Facebook login UX
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:true
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
          if(!error){
              switch (status) {
                  case FBSessionStateClosed:
                      DLog(@"FBSessionStateClosed ");
                  case FBSessionStateClosedLoginFailed:
                      DLog(@"FBSessionStateClosedLoginFailed ");
                  case FBSessionStateCreatedOpening:
                      DLog(@"FBSessionStateCreatedOpening ");
                      // If so, just send them round the loop again
                      [[FBSession activeSession] closeAndClearTokenInformation];
                      [FBSession setActiveSession:nil];
                      [self createFbSession];
                      isFbLoggedIn = false;
                      callback(false);
                      break;
                  case FBSessionStateCreatedTokenLoaded:
                      DLog(@"FBSessionStateCreatedTokenLoaded ");
                  case FBSessionStateOpen:
                      DLog(@"FBSessionStateOpen Done");
                  case FBSessionStateOpenTokenExtended:
                      DLog(@"FBSessionStateOpenTokenExtended ");
                  case FBSessionStateCreated:
                      DLog(@"FBSessionStateCreated ");
                      [self fetchUserDetail:^(bool done){
                          DLog(@"FetchUserDetail ");
                      }];
                      isFbLoggedIn = true;
                      callback(true);
                      break;
                  default:
                      break;
              }
          }
         else{
             DLog(@"Error: %@",[FBErrorUtility userMessageForError:error]);
         }
    }];
}

-(void)fetchUserDetail:(void (^)(bool))callback
{
    // Start the facebook request
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error)
     {
         // Did everything come back okay with no errors?
         if (!error && result) {
             DLog(@"%@",result);
             // If so we can extract out the player's Facebook ID and first name
             NSString* firsName     = [[NSString alloc] initWithString:result.first_name];
             NSString* lastName     = [[NSString alloc] initWithString:result.last_name];
             NSString* middleName   = [[NSString alloc] initWithString:result.middle_name];
             long userFbId          =  [result.objectID longLongValue];
             [self.facebookUserDetail setObject:firsName forKey:@"firstname"];
             [self.facebookUserDetail setObject:lastName forKey:@"lastname"];
             [self.facebookUserDetail setObject:middleName forKey:@"middlename"];
             [self.facebookUserDetail setObject:result.objectID forKey:@"fbId"];
             callback(true);
         }
         else {
             DLog(@"Error: %@",[FBErrorUtility userMessageForError:error]);
             callback(false);
         }
     }];
}

-(void)trackNewGame{
    // Set screen name on the tracker to be sent with all hits.
    [tracker set:kGAIScreenName value:@"GameScene"];
    // Send a screen view for "GameScene".
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    // This event will also be sent with &cd=GameScene.
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:@"New Game"
                                                           value:nil] build]];
    // Clear the screen name field when we're done.
    [tracker set:kGAIScreenName value:nil];
}

-(void)trackPlayAgain{
    // Set screen name on the tracker to be sent with all hits.
    [tracker set:kGAIScreenName value:@"GameScene"];
    // Send a screen view for "GameScene".
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    // This event will also be sent with &cd=GameScene.
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:@"Play Again"
                                                           value:nil] build]];
    // Clear the screen name field when we're done.
    [tracker set:kGAIScreenName value:nil];
}

-(void)trackShareFacebook{
    // Set screen name on the tracker to be sent with all hits.
    [tracker set:kGAIScreenName value:@"GameScene"];
    // Send a screen view for "GameScene".
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    // This event will also be sent with &cd=GameScene.
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:@"Share Facebook"
                                                           value:nil] build]];
    // Clear the screen name field when we're done.
    [tracker set:kGAIScreenName value:nil];
}

@end

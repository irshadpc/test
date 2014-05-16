//
//  Game.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//

#import "Game.h"
#import "GAIDictionaryBuilder.h"
#import <FacebookSDK/FacebookSDK.h>

#define KEY_HIGHT_SCORE @"fl_hight_score"
#define kGAIScreenName @"Scene Name"

static Game *instance = nil;
@implementation Game{

}
@synthesize currentValue, currentScore, highestScore, valueColorMapsDictionary, colorMap, gameState, isFbLoggedIn, facebookUserDetail, tracker, soundOn;

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
        [self loadCurrentUserInfo];
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

-(void)turnSound:(BOOL)on{
    if(soundOn == on) return;
    soundOn = on;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:soundOn] forKey:@"soundOn"];
}

-(void)updateHightScore:(long)newHigheScore;
{
    highestScore = newHigheScore;
    [[NSUserDefaults standardUserDefaults] setInteger:highestScore forKey:KEY_HIGHT_SCORE];
}
-(void)loadCurrentUserInfo
{
    NSUserDefaults *sharedUserDefault = [NSUserDefaults standardUserDefaults];
    NSInteger highScore = [sharedUserDefault integerForKey:KEY_HIGHT_SCORE];
    highestScore = (long)highScore;
    currentScore = 0;
    currentValue = 1;
    NSNumber *soundOnId = [[NSUserDefaults standardUserDefaults] objectForKey:@"soundOn"];
    if(!soundOnId)
    {
        soundOn = YES;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:soundOn] forKey:@"soundOn"];
    }
    soundOn = [[[NSUserDefaults standardUserDefaults] objectForKey:@"soundOn"] boolValue];
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
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_actions",nil];
    // Attempt to open the session. If the session is not open, show the user the Facebook login UX
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:true
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                  if(!error){
                      // Did something go wrong during login? I.e. did the user cancel?
                      if (status == FBSessionStateClosedLoginFailed || status == FBSessionStateClosed || status == FBSessionStateCreatedOpening) {
                          isFbLoggedIn = false;
                          callback(false);
                      }
                      else {
                          isFbLoggedIn = true;
                          callback(true);
                      }

                  }else{
                      DLog(@"Error: %@",[FBErrorUtility userMessageForError:error]);
                  }
            }];
}

#define  APP_LINK @"https://developers.facebook.com/docs/ios/share/"
//
//-(void)login:(void (^)(bool))callback
//{
//    DLog(@"Start");
//    // Whenever a person opens the app, check for a cached session
//    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        // If there's one, just open the session silently, without showing the user the login UI
//        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
//                                           allowLoginUI:NO
//                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//                                          // Handler for session state changes
//                                          // This method will be called EACH time the session state changes,
//                                          // also for intermediate states and NOT just when the session open
//                                          [self sessionStateChanged:session state:state error:error];
//                                      }];
//    }
//    else if (FBSession.activeSession.state != FBSessionStateOpen){
//        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
//                                           allowLoginUI:YES
//                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//                                          // Handler for session state changes
//                                          // This method will be called EACH time the session state changes,
//                                          // also for intermediate states and NOT just when the session open
//                                          [self sessionStateChanged:session state:state error:error];
//                                      }];
//    }
//    else{
//        DLog(@"%@", FBSession.activeSession);
//        [self shareFb:^(bool successful) {
//            
//        }];
//    }
//}
//
//// This method will handle ALL the session state changes in the app
//- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
//{
//    DLog(@"Start");
//    // If the session was opened successfully
//    if (!error && state == FBSessionStateOpen){
//        NSLog(@"Session opened");
//        // Show the user the logged-in UI
//        //[self userLoggedIn];
//        [self shareFb:^(bool successful) {
//            
//        }];
//        return;
//    }
//    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
//        // If the session is closed
//        NSLog(@"Session closed");
//        [FBSession.activeSession closeAndClearTokenInformation];
//
//    }
//    
//    // Handle errors
//    if (error){
//        NSLog(@"Error");
//        NSString *alertText;
//        NSString *alertTitle;
//        // If the error requires people using an app to make an action outside of the app in order to recover
//        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
//            alertTitle = @"Something went wrong";
//            alertText = [FBErrorUtility userMessageForError:error];
//            //            [self showMessage:alertText withTitle:alertTitle];
//        } else {
//            
//            // If the user cancelled login, do nothing
//            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
//                NSLog(@"User cancelled login");
//                
//                // Handle session closures that happen outside of the app
//            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
//                alertTitle = @"Session Error";
//                alertText = @"Your current session is no longer valid. Please log in again.";
//                //                [self showMessage:alertText withTitle:alertTitle];
//                
//                // Here we will handle all other errors with a generic error message.
//                // We recommend you check our Handling Errors guide for more information
//                // https://developers.facebook.com/docs/ios/errors/
//            } else {
//                //Get more error information from the error
//                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
//                
//                // Show the user an error message
//                alertTitle = @"Something went wrong";
//                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
//                //                [self showMessage:alertText withTitle:alertTitle];
//            }
//        }
//        // Clear this token
//        [FBSession.activeSession closeAndClearTokenInformation];
//        // Show the user the logged-out UI
//        //        [self userLoggedOut];
//    }
//}

-(void)shareFb:(void (^)(bool))callback{
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:APP_LINK];
    BOOL canShare = [FBDialogs canPresentShareDialogWithParams:params];
    if (canShare) {
        NSArray* images = @[
                            @{@"url": [UIImage imageNamed:@"share.jpg"], @"user_generated" : @"true" }
                            ];
        id<FBGraphObject> mealObject =
        [FBGraphObject openGraphObjectForPostWithType:@"cooking-app:meal"
                                                title:@"Lamb Vindaloo"
                                                image:images
                                                  url:@"https://example.com/cooking-app/meal/Lamb-Vindaloo.html"
                                          description:@"Spicy curry of lamb and potatoes"];
        
        id<FBOpenGraphAction> cookAction = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
        [cookAction setObject:mealObject forKey:@"meal"];
        [FBDialogs presentShareDialogWithOpenGraphAction:cookAction
                                              actionType:@"cooking-app:cook"
                                     previewPropertyName:@"meal"
                                                 handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                     if(error) {
                                                         DLog(@"Error: %@", error.description);
                                                     } else {
                                                         DLog(@"Success!");
                                                     }
                                                 }];
    }
    else{
        // FALLBACK: publish just a link using the Feed dialog
        // Show the feed dialog
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Sharing Tutorial", @"name",
                                       @"Build great social apps and get more installs.", @"caption",
                                       @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                       APP_LINK, @"link",
                                       @"https://fbcdn-photos-f-a.akamaihd.net/hphotos-ak-prn2/t39.2081-0/10333116_886921368000612_183850266_n.jpg", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          DLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              DLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  DLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  DLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

//-(void)fetchUserDetail:(void (^)(bool))callback
//{
//    // Start the facebook request
//    [[FBRequest requestForMe] startWithCompletionHandler:
//     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error)
//     {
//         // Did everything come back okay with no errors?
//         if (!error && result) {
//             DLog(@"%@",result);
//             // If so we can extract out the player's Facebook ID and first name
//             NSString* firsName     = [[NSString alloc] initWithString:result.first_name];
//             NSString* lastName     = [[NSString alloc] initWithString:result.last_name];
//             NSString* middleName   = [[NSString alloc] initWithString:result.middle_name];
//             long userFbId          =  [result.objectID longLongValue];
//             [self.facebookUserDetail setObject:firsName forKey:@"firstname"];
//             [self.facebookUserDetail setObject:lastName forKey:@"lastname"];
//             [self.facebookUserDetail setObject:middleName forKey:@"middlename"];
//             [self.facebookUserDetail setObject:result.objectID forKey:@"fbId"];
//             callback(true);
//         }
//         else {
//             DLog(@"Error: %@",[FBErrorUtility userMessageForError:error]);
//             callback(false);
//         }
//     }];
//}

-(void)shareFb{
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/au/app/impossible-flappy-flappys/id845040429?mt=8"];
    NSURL *picUrl = [NSURL URLWithString:@"https://fbcdn-photos-d-a.akamaihd.net/hphotos-ak-prn2/t39.2081-0/p128x128/10333115_886778698014879_689012476_n.png"];
//    [FBDialogs presentShareDialogWithLink:url
//                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                      if(error) {
//                                          NSLog(@"Error: %@", error.description);
//                                      } else {
//                                          NSLog(@"Success!");
//                                      }
//                                  }];
//    [FBDialogs presentShareDialogWithLink:nil name:@"Flappy 2048" caption:@"Flappy 2048 Caption" description:@"Flappy 2048 Description" picture:picUrl clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//        if(error) {
//            DLog(@"Error: %@", error.description);
//        } else {
//            DLog(@"Success!");
//        }
//
//    }];
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = url;
    params.picture = picUrl;
    params.name = [NSString  stringWithFormat:@"I scored %ld in Flappy 2048! Can you beat that?",highestScore];

    [FBDialogs presentShareDialogWithParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
        
    }];
//    NSArray* images = @[
//                        @{@"url": [UIImage imageNamed:@"share.jpg"], @"user_generated" : @"true" }
//                        ];
//    id<FBGraphObject> mealObject =
//    [FBGraphObject openGraphObjectForPostWithType:@"cooking-app:meal"
//                                            title:@"Lamb Vindaloo"
//                                            image:images
//                                              url:@"https://example.com/cooking-app/meal/Lamb-Vindaloo.html"
//                                      description:@"Spicy curry of lamb and potatoes"];
//    
//    id<FBOpenGraphAction> cookAction = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
//    [cookAction setObject:mealObject forKey:@"meal"];
//    [FBDialogs presentShareDialogWithOpenGraphAction:cookAction
//                                          actionType:@"cooking-app:cook"
//                                 previewPropertyName:@"meal"
//                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                                 if(error) {
//                                                     NSLog(@"Error: %@", error.description);
//                                                 } else {
//                                                     NSLog(@"Success!");
//                                                 }
//                                             }];
}
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
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

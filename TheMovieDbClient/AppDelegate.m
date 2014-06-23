//
//  AppDelegate.m
//  TheMovieDbClient
//
//  Created by mac-214 on 22.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <CoreData/CoreData.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordonator = _persistentStoreCoordonator;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    MainViewController *viewcontroller = [[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil] autorelease];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
    self.window.rootViewController = navigationController;    
    [self.window makeKeyAndVisible];   
  
    [navigationController release];
    
    return YES;

}

- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordonator];
    if(coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel
{
    if(_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordonator
{
    if(_persistentStoreCoordonator != nil)
    {
        return _persistentStoreCoordonator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"SearchAutocomplete.sqlite"]];
    
    NSError *error = nil;
    _persistentStoreCoordonator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![_persistentStoreCoordonator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"SQLITE Error - NSPersistentStoreCoordinator");
    }
    
    return  _persistentStoreCoordonator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSArray *) getAllRecords
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc]init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SearchRecord" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSError *error;    
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}
 

@end

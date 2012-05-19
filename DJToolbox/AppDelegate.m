//
//  AppDelegate.m
//  DJToolbox
//
//  Created by Nik Reiman on 5/18/12.
//  Copyright (c) 2012 Teragon Audio. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize currentLibraryLocation = _currentLibraryLocation;
@synthesize window = _window;
@synthesize libraryComboBox = _libraryComboBox;
@synthesize statusTextField = _statusTextField;
@synthesize progressIndicator = _progressIndicator;
@synthesize unwarpedTracksOutputFolderTextField = _unwarpedTracksOutputFolderTextField;
@synthesize orphanedAsdsBrowser = _orphanedAsdsBrowser;
@synthesize conflictedFilesBrowser = _conflictedFilesBrowser;
@synthesize orphanedTracksBrowser = _orphanedTracksBrowser;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSArray *pastLibraryLocations = [userDefaults arrayForKey:kDefaultsKeyPastLibraryLocations];
  [self.libraryComboBox addItemsWithObjectValues:pastLibraryLocations];
  [self.libraryComboBox setStringValue:[userDefaults objectForKey:kDefaultsKeyLastLibraryLocation]];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
  return YES;
}


- (NSString *)getiTunesLibraryLocation {
  return self.currentLibraryLocation;
}

- (IBAction)browseLibraryLocation:(id)sender {
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  openPanel.canChooseFiles = NO;
  openPanel.canChooseDirectories = YES;
  openPanel.allowsMultipleSelection = NO;
  [openPanel runModal];
  [self.libraryComboBox addItemWithObjectValue:openPanel.filename];
  [self.libraryComboBox setStringValue:openPanel.filename];

  self.currentLibraryLocation = openPanel.filename;
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSArray *pastLibraryLocations = [userDefaults arrayForKey:kDefaultsKeyPastLibraryLocations];
  NSMutableArray *savedLibraryLocations = [NSMutableArray arrayWithArray:pastLibraryLocations];
  BOOL shouldAddLocation = YES;
  for(NSString *location in savedLibraryLocations) {
    if([location isEqualToString:self.currentLibraryLocation]) {
      shouldAddLocation = NO;
      break;
    }
  }
  if(shouldAddLocation) {
    [savedLibraryLocations addObject:self.currentLibraryLocation];
    [userDefaults setObject:savedLibraryLocations forKey:kDefaultsKeyPastLibraryLocations];
  }
  [userDefaults setObject:self.currentLibraryLocation forKey:kDefaultsKeyLastLibraryLocation];
}

- (IBAction)browseUnwarpedTracksOutputFolder:(id)sender {

}

- (IBAction)generateUnwarpedTracksPlaylist:(id)sender {

}

- (IBAction)findOrphanedAsds:(id)sender {

}

- (IBAction)findConflictedFiles:(id)sender {

}

- (IBAction)useMineForConflictedFile:(id)sender {

}

- (IBAction)useTheirsForConflictedFile:(id)sender {

}

- (IBAction)cleanJunkFiles:(id)sender {

}

- (IBAction)findOrphanedFiles:(id)sender {

}

- (IBAction)addOrphanedTracksToLibrary:(id)sender {

}


- (void)dealloc {
  [super dealloc];
}

@end

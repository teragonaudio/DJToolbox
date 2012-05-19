//
//  AppDelegate.m
//  DJToolbox
//
//  Created by Nik Reiman on 5/18/12.
//  Copyright (c) 2012 Teragon Audio. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize libraryComboBox = _libraryComboBox;
@synthesize statusTextField = _statusTextField;
@synthesize progressIndicator = _progressIndicator;
@synthesize unwarpedTracksOutputFolderTextField = _unwarpedTracksOutputFolderTextField;
@synthesize orphanedAsdsBrowser = _orphanedAsdsBrowser;
@synthesize conflictedFilesBrowser = _conflictedFilesBrowser;
@synthesize orphanedTracksBrowser = _orphanedTracksBrowser;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
  return YES;
}


- (NSString *)getiTunesLibraryLocation {
  return self.libraryComboBox.stringValue;
}

- (IBAction)browseLibraryLocation:(id)sender {

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

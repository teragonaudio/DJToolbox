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
@synthesize abletonPlaylistOutputFolderTextField = _abletonPlaylistOutputFolderTextField;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
  return YES;
}

- (NSString *)getiTunesLibraryLocation {
  return self.libraryComboBox.stringValue;
}

- (IBAction)abletonBrowsePlaylistOutputFolder:(id)sender {

}

- (IBAction)abletonGeneratePlaylist:(id)sender {
}

- (void)dealloc {
  [super dealloc];
}

@end

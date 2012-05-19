//
//  AppDelegate.h
//  DJToolbox
//
//  Created by Nik Reiman on 5/18/12.
//  Copyright (c) 2012 Teragon Audio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LibraryLocationProvider.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, LibraryLocationProvider>

#pragma mark Main Window Controls
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSComboBox *libraryComboBox;
@property (assign) IBOutlet NSTextField *statusTextField;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;
- (IBAction)browseLibraryLocation:(id)sender;

#pragma mark Ableton Live Tab
@property (assign) IBOutlet NSTextField *unwarpedTracksOutputFolderTextField;
@property (assign) IBOutlet NSBrowser *orphanedAsdsBrowser;
- (IBAction)browseUnwarpedTracksOutputFolder:(id)sender;
- (IBAction)generateUnwarpedTracksPlaylist:(id)sender;
- (IBAction)findOrphanedAsds:(id)sender;

#pragma mark Dropbox Tab
@property (assign) IBOutlet NSBrowser *conflictedFilesBrowser;
- (IBAction)findConflictedFiles:(id)sender;
- (IBAction)useMineForConflictedFile:(id)sender;
- (IBAction)useTheirsForConflictedFile:(id)sender;

#pragma mark Finder Tab
- (IBAction)cleanJunkFiles:(id)sender;

#pragma mark iTunes Tab
@property (assign) IBOutlet NSBrowser *orphanedTracksBrowser;
- (IBAction)findOrphanedFiles:(id)sender;
- (IBAction)addOrphanedTracksToLibrary:(id)sender;

@end

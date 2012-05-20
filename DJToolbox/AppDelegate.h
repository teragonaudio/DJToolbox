//
//  AppDelegate.h
//  DJToolbox
//
//  Created by Nik Reiman on 5/18/12.
//  Copyright (c) 2012 Teragon Audio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LibraryLocationProvider.h"

@class OrphanedAsdsController;

static NSString *const kDefaultsKeyPastLibraryLocations = @"Past Library Locations";
static NSString *const kDefaultsKeyLastLibraryLocation = @"Last Library Location";
static NSString *const kDefaultsKeyLastUnwarpedTracksOutputFolder = @"Last Unwarped Tracks Output Folder";

static NSString *const kDefaultOutputPlaylistName = @"/unwarped.m3u8";
static NSString *const kiTunesTopLevelSubfolder = @"/iTunes Media/Music";

@interface AppDelegate : NSObject <NSApplicationDelegate, LibraryLocationProvider>

#pragma mark Internal Members
@property (assign, nonatomic) NSString *currentLibraryLocation;
@property (assign, nonatomic) NSString *unwarpedTracksOutputLocation;
@property (readonly) NSArray *recognizedAudioFileExtensions;

#pragma mark Main Window Controls
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSComboBox *libraryComboBox;
@property (assign) IBOutlet NSTextField *statusTextField;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;
- (IBAction)browseLibraryLocation:(id)sender;

#pragma mark Ableton Live Tab
@property (assign) IBOutlet NSTextField *unwarpedTracksOutputFolderTextField;
@property (assign) IBOutlet NSButton *unwarpedTracksGeneratePlaylistButton;
@property (assign) IBOutlet NSBrowser *orphanedAsdsBrowser;
@property (assign) IBOutlet NSButton *findOrphanedAsdsButton;
@property (assign, nonatomic) OrphanedAsdsController *orphanedAsdsController;
- (IBAction)browseUnwarpedTracksOutputFolder:(id)sender;
- (IBAction)generateUnwarpedTracksPlaylist:(id)sender;
- (IBAction)findOrphanedAsds:(id)sender;

#pragma mark Dropbox Tab
@property (assign) IBOutlet NSBrowser *conflictedFilesBrowser;
@property (assign) IBOutlet NSButton *findConflictedFilesButton;
@property (assign) IBOutlet NSButton *conflictedFilesUseMineButton;
@property (assign) IBOutlet NSButton *conflictedFilesUseTheirsButton;
- (IBAction)findConflictedFiles:(id)sender;
- (IBAction)useMineForConflictedFile:(id)sender;
- (IBAction)useTheirsForConflictedFile:(id)sender;

#pragma mark Finder Tab
@property (assign) IBOutlet NSButton *cleanJunkFilesButton;
- (IBAction)cleanJunkFiles:(id)sender;

#pragma mark iTunes Tab
@property (assign) IBOutlet NSButton *findOrphanedTracksButton;
@property (assign) IBOutlet NSButton *addOrphanedTracksToLibraryButton;
@property (assign) IBOutlet NSBrowser *orphanedTracksBrowser;
- (IBAction)findOrphanedFiles:(id)sender;
- (IBAction)addOrphanedTracksToLibrary:(id)sender;

@end

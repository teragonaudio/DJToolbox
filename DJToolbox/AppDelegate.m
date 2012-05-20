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
@synthesize unwarpedTracksGeneratePlaylistButton = _unwarpedTracksGeneratePlaylistButton;
@synthesize orphanedAsdsBrowser = _orphanedAsdsBrowser;
@synthesize findOrphanedAsdsButton = _findOrphanedAsdsButton;

@synthesize conflictedFilesBrowser = _conflictedFilesBrowser;
@synthesize findConflictedFilesButton = _findConflictedFilesButton;
@synthesize conflictedFilesUseMineButton = _conflictedFilesUseMineButton;
@synthesize conflictedFilesUseTheirsButton = _conflictedFilesUseTheirsButton;

@synthesize cleanJunkFilesButton = _cleanJunkFilesButton;

@synthesize findOrphanedTracksButton = _findOrphanedTracksButton;
@synthesize addOrphanedTracksToLibraryButton = _addOrphanedTracksToLibraryButton;
@synthesize orphanedTracksBrowser = _orphanedTracksBrowser;


- (NSString *)getiTunesLibraryLocation {
  return self.currentLibraryLocation;
}

- (NSArray *)recognizedAudioFileExtensions {
  return [NSArray arrayWithObjects:@"mp3", @"m4a", @"flac", @"ogg", nil];
}

- (NSString *)lastUnwarpedTracksOutputFolder {
  NSString *outputPath = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultsKeyLastUnwarpedTracksOutputFolder];
  if(outputPath == nil) {
    return [NSHomeDirectory() stringByAppendingString:@"/Desktop"];
  }
  else {
    return outputPath;
  }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSArray *pastLibraryLocations = [userDefaults arrayForKey:kDefaultsKeyPastLibraryLocations];
  [self.libraryComboBox addItemsWithObjectValues:pastLibraryLocations];
  self.currentLibraryLocation = [userDefaults objectForKey:kDefaultsKeyLastLibraryLocation];
  [self.libraryComboBox setStringValue:self.currentLibraryLocation];

  [self.unwarpedTracksOutputFolderTextField setStringValue:[self lastUnwarpedTracksOutputFolder]];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
  return YES;
}

- (void)setProgressMessage:(NSString *)message {
  NSLog(@"%@", message);
  [self.statusTextField setStringValue:message];
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
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  openPanel.canChooseFiles = NO;
  openPanel.canChooseDirectories = YES;
  openPanel.allowsMultipleSelection = NO;
  [openPanel runModal];
  [self.unwarpedTracksOutputFolderTextField setStringValue:openPanel.filename];
}

- (NSInteger)searchForUnwarpedTracks:(NSString *)directory outputFile:(FILE *)outputFile numFilesFound:(NSInteger)numFilesFound {
  NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
  NSError *error;
  NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:directory error:&error];
  for(NSString *item in directoryContents) {
    NSString *absoluteItemPath = [directory stringByAppendingFormat:@"/%@", item];
    BOOL isDirectory = NO;
    if([fileManager fileExistsAtPath:absoluteItemPath isDirectory:&isDirectory]) {
      if(isDirectory) {
        numFilesFound = [self searchForUnwarpedTracks:absoluteItemPath outputFile:outputFile numFilesFound:numFilesFound];
      }
      else {
        NSRange lastDot = [absoluteItemPath rangeOfString:@"." options:NSBackwardsSearch];
        if(lastDot.location != NSNotFound) {
          NSString *extension = [absoluteItemPath substringFromIndex:lastDot.location + 1];
          if([extension isEqualToString:@"asd"]) {
            continue;
          }
          else if([self.recognizedAudioFileExtensions containsObject:[extension lowercaseString]]) {
            NSString *asdPath = [absoluteItemPath stringByAppendingString:@".asd"];
            if(![fileManager fileExistsAtPath:asdPath]) {
              numFilesFound++;
              if(numFilesFound == 1) {
                [self setProgressMessage:[NSString stringWithFormat:@"%d file found", numFilesFound]];
              }
              else {
                [self setProgressMessage:[NSString stringWithFormat:@"%d files found", numFilesFound]];
              }
              fprintf(outputFile, "%s\n", [absoluteItemPath cStringUsingEncoding:NSMacOSRomanStringEncoding]);
            }
          }
        }
      }
    }
  }
  return numFilesFound;
}

- (IBAction)generateUnwarpedTracksPlaylist:(id)sender {
  NSString *outputFilePath = [self.unwarpedTracksOutputFolderTextField.stringValue stringByAppendingString:kDefaultOutputPlaylistName];
  NSString *topDirectory = [self.currentLibraryLocation stringByAppendingString:kiTunesTopLevelSubfolder];
  FILE *outputFile = fopen([outputFilePath cStringUsingEncoding:NSASCIIStringEncoding], "w");
  [self setProgressMessage:@"Search started..."];
  [_progressIndicator startAnimation:sender];
  NSInteger numFilesFound = 0;
  [self searchForUnwarpedTracks:topDirectory outputFile:outputFile numFilesFound:numFilesFound];
  [_progressIndicator stopAnimation:sender];
  fclose(outputFile);
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

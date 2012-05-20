//
//  AppDelegate.m
//  DJToolbox
//
//  Created by Nik Reiman on 5/18/12.
//  Copyright (c) 2012 Teragon Audio. All rights reserved.
//

#import "AppDelegate.h"
#import "OrphanedAsdsController.h"

@implementation AppDelegate

@synthesize currentLibraryLocation = _currentLibraryLocation;
@synthesize unwarpedTracksOutputLocation = _unwarpedTracksOutputLocation;

@synthesize window = _window;
@synthesize libraryComboBox = _libraryComboBox;
@synthesize statusTextField = _statusTextField;
@synthesize progressIndicator = _progressIndicator;

@synthesize unwarpedTracksOutputFolderTextField = _unwarpedTracksOutputFolderTextField;
@synthesize unwarpedTracksGeneratePlaylistButton = _unwarpedTracksGeneratePlaylistButton;
@synthesize orphanedAsdsBrowser = _orphanedAsdsBrowser;
@synthesize findOrphanedAsdsButton = _findOrphanedAsdsButton;
@synthesize orphanedAsdsController = _orphanedAsdsController;

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
  self.unwarpedTracksOutputLocation = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultsKeyLastUnwarpedTracksOutputFolder];
  if(self.unwarpedTracksOutputLocation == nil) {
    return [NSHomeDirectory() stringByAppendingString:@"/Desktop"];
  }
  else {
    return self.unwarpedTracksOutputLocation;
  }
}

- (void)revealFileInFinder:(id)sender {
  NSBrowser *browser = sender;
  NSString *selectedFile = [[browser selectedCell] title];
  [[NSWorkspace sharedWorkspace] selectFile:selectedFile inFileViewerRootedAtPath: nil];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSArray *pastLibraryLocations = [userDefaults arrayForKey:kDefaultsKeyPastLibraryLocations];
  [self.libraryComboBox addItemsWithObjectValues:pastLibraryLocations];
  self.currentLibraryLocation = [userDefaults objectForKey:kDefaultsKeyLastLibraryLocation];
  [self.libraryComboBox setStringValue:self.currentLibraryLocation];

  [self.unwarpedTracksOutputFolderTextField setStringValue:[self lastUnwarpedTracksOutputFolder]];
  self.orphanedAsdsController = [[OrphanedAsdsController alloc] init];
  [self.orphanedAsdsBrowser setDelegate:self.orphanedAsdsController];
  [self.orphanedAsdsBrowser setAction:@selector(revealFileInFinder:)];
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

  [self.unwarpedTracksGeneratePlaylistButton setEnabled:(self.currentLibraryLocation && self.unwarpedTracksOutputLocation)];
}

- (IBAction)browseUnwarpedTracksOutputFolder:(id)sender {
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  openPanel.canChooseFiles = NO;
  openPanel.canChooseDirectories = YES;
  openPanel.allowsMultipleSelection = NO;
  [openPanel runModal];
  self.unwarpedTracksOutputLocation = openPanel.filename;
  [self.unwarpedTracksOutputFolderTextField setStringValue:self.unwarpedTracksOutputLocation];
  [self.unwarpedTracksGeneratePlaylistButton setEnabled:(self.currentLibraryLocation && self.unwarpedTracksOutputLocation)];
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
  [self.unwarpedTracksGeneratePlaylistButton setEnabled:NO];
  [_progressIndicator startAnimation:sender];
  NSInteger numFilesFound = [self searchForUnwarpedTracks:topDirectory outputFile:outputFile numFilesFound:0];
  [_progressIndicator stopAnimation:sender];
  [self setProgressMessage:[NSString stringWithFormat:@"Done, %d files found", numFilesFound]];
  [self.unwarpedTracksGeneratePlaylistButton setEnabled:YES];
  fclose(outputFile);
}

- (NSInteger)searchForOrphanedAsds:(NSString *)directory numFilesFound:(NSInteger)numFilesFound {
  NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
  NSError *error;
  NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:directory error:&error];
  for(NSString *item in directoryContents) {
    NSString *absoluteItemPath = [directory stringByAppendingFormat:@"/%@", item];
    BOOL isDirectory = NO;
    if([fileManager fileExistsAtPath:absoluteItemPath isDirectory:&isDirectory]) {
      if(isDirectory) {
        numFilesFound = [self searchForOrphanedAsds:absoluteItemPath numFilesFound:numFilesFound];
      }
      else {
        NSRange lastDot = [absoluteItemPath rangeOfString:@"." options:NSBackwardsSearch];
        if(lastDot.location != NSNotFound) {
          NSString *extension = [absoluteItemPath substringFromIndex:lastDot.location + 1];
          if([extension isEqualToString:@"asd"]) {
            NSString *musicFileName = [absoluteItemPath substringToIndex:lastDot.location];
            if(![fileManager fileExistsAtPath:musicFileName]) {
              [self.orphanedAsdsController addOrphanedAsd:absoluteItemPath];
              numFilesFound++;
              if(numFilesFound == 1) {
                [self setProgressMessage:[NSString stringWithFormat:@"%d file found", numFilesFound]];
              }
              else {
                [self setProgressMessage:[NSString stringWithFormat:@"%d files found", numFilesFound]];
              }
            }
          }
        }
      }
    }
  }
  return numFilesFound;
}

- (IBAction)findOrphanedAsds:(id)sender {
  [self setProgressMessage:@"Search started..."];
  [self.findOrphanedAsdsButton setEnabled:NO];
  [_progressIndicator startAnimation:sender];
  NSString *topDirectory = [self.currentLibraryLocation stringByAppendingString:kiTunesTopLevelSubfolder];
  NSInteger numFilesFound = [self searchForOrphanedAsds:topDirectory numFilesFound:0];
  [self.orphanedAsdsBrowser reloadColumn:0];
  [_progressIndicator stopAnimation:sender];
  [self setProgressMessage:[NSString stringWithFormat:@"Done, %d files found", numFilesFound]];
  [self.findOrphanedAsdsButton setEnabled:YES];
}


- (IBAction)findConflictedFiles:(id)sender {

}

- (IBAction)useMineForConflictedFile:(id)sender {

}

- (IBAction)useTheirsForConflictedFile:(id)sender {

}


- (NSInteger)cleanJunkFiles:(NSString *)directory numFilesCleaned:(NSInteger)numFilesCleaned {
  NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
  NSError *error;
  NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:directory error:&error];
  for(NSString *item in directoryContents) {
    NSString *absoluteItemPath = [directory stringByAppendingFormat:@"/%@", item];
    BOOL isDirectory = NO;
    if([fileManager fileExistsAtPath:absoluteItemPath isDirectory:&isDirectory]) {
      if(isDirectory) {
        if([item isEqualToString:@"__MACOSX"]) {
          if([fileManager removeItemAtPath:item error:&error]) {
            numFilesCleaned++;
            if(numFilesCleaned == 1) {
              [self setProgressMessage:[NSString stringWithFormat:@"%d item cleaned", numFilesCleaned]];
            }
            else {
              [self setProgressMessage:[NSString stringWithFormat:@"%d items cleaned", numFilesCleaned]];
            }
          }
          else {
            NSLog(@"Failed removing file: %@", error);
          }
        }
        else {
          numFilesCleaned = [self cleanJunkFiles:absoluteItemPath numFilesCleaned:numFilesCleaned];
        }
      }
      else {
        BOOL shouldRemoveFile = NO;
        if([item isEqualToString:@".DS_Store"]) {
          shouldRemoveFile = YES;
        }
        else {
          NSRange matchStart = [item rangeOfString:@"._" options:NSAnchoredSearch];
          if(matchStart.location != NSNotFound) {
            shouldRemoveFile = YES;
          }
        }

        if(shouldRemoveFile) {
          if([fileManager removeItemAtPath:absoluteItemPath error:&error]) {
            numFilesCleaned++;
            if(numFilesCleaned == 1) {
              [self setProgressMessage:[NSString stringWithFormat:@"%d item cleaned", numFilesCleaned]];
            }
            else {
              [self setProgressMessage:[NSString stringWithFormat:@"%d items cleaned", numFilesCleaned]];
            }
          }
          else {
            NSLog(@"Failed removing file: %@", error);
          }
        }
      }
    }
  }
  return numFilesCleaned;
}

- (IBAction)cleanJunkFiles:(id)sender {
  [self setProgressMessage:@"Clean started..."];
  [self.cleanJunkFilesButton setEnabled:NO];
  [_progressIndicator startAnimation:sender];
  NSInteger numFilesCleaned = [self cleanJunkFiles:self.currentLibraryLocation numFilesCleaned:0];
  [_progressIndicator stopAnimation:sender];
  [self setProgressMessage:[NSString stringWithFormat:@"Done, %d files removed", numFilesCleaned]];
  [self.cleanJunkFilesButton setEnabled:YES];
}


- (IBAction)findOrphanedFiles:(id)sender {

}

- (IBAction)addOrphanedTracksToLibrary:(id)sender {

}


- (void)dealloc {
  [_orphanedAsdsController release];
  [super dealloc];
}

@end

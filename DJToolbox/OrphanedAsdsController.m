//
// Created by nik on 5/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "OrphanedAsdsController.h"


@implementation OrphanedAsdsController

@synthesize orphanedAsds = _orphanedAsds;

- (id)init {
  self = [super init];
  if(self) {
    self.orphanedAsds = [[NSMutableArray alloc] init];
  }

  return self;
}

- (NSString *)browser:(NSBrowser *)sender titleOfColumn:(NSInteger)column {
  return @"File";
}

- (CGFloat)browser:(NSBrowser *)browser heightOfRow:(NSInteger)row inColumn:(NSInteger)columnIndex {
  return 24;
}

- (NSInteger)count {
  return self.orphanedAsds ? [self.orphanedAsds count] : 0;
}

- (NSInteger)browser:(NSBrowser *)sender numberOfRowsInColumn:(NSInteger)column {
  return [self count];
}

- (id)rootItemForBrowser:(NSBrowser *)browser {
  NSTextField *textField = [[[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)] autorelease];
  [textField setStringValue:@"/"];
  return textField;
}

- (BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item {
  return YES;
}

- (void)browser:(NSBrowser *)sender willDisplayCell:(id)cell atRow:(NSInteger)row column:(NSInteger)column {
  NSBrowserCell *browserCell = cell;
  [browserCell setTitle:[self.orphanedAsds objectAtIndex:(NSUInteger)row]];
}

- (BOOL)browser:(NSBrowser *)sender selectRow:(NSInteger)row inColumn:(NSInteger)column {
  [[NSWorkspace sharedWorkspace] selectFile:[self.orphanedAsds objectAtIndex:(NSUInteger)row] inFileViewerRootedAtPath:nil];
  return YES;
}

- (void)addOrphanedAsd:(NSString *)filename {
  [self.orphanedAsds addObject:filename];
}

- (void)dealloc {
  [_orphanedAsds release];
  [super dealloc];
}

@end
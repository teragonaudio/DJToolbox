//
// Created by nik on 5/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "FoundFilesController.h"

@interface FoundFilesController ()

@property (assign, nonatomic) NSMutableArray *orphanedAsds;
@property (assign, nonatomic) NSMutableArray *displayNames;

@end


@implementation FoundFilesController

@synthesize orphanedAsds = _orphanedAsds;
@synthesize displayNames = _displayNames;


- (id)init {
  self = [super init];
  if(self) {
    self.orphanedAsds = [[NSMutableArray alloc] init];
    self.displayNames = [[NSMutableArray alloc] init];
  }

  return self;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSCell *tableCell = cell;
  NSString *displayTitle = [@"…" stringByAppendingString:[self.displayNames objectAtIndex:(NSUInteger)row]];
  [tableCell setTitle:displayTitle];
}

- (NSString *)pathForSelectedCell:(NSTableView *)tableView {
  NSUInteger selectedCell = (NSUInteger)[tableView selectedRow];
  return [self.orphanedAsds objectAtIndex:selectedCell];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return [self.orphanedAsds objectAtIndex:(NSUInteger)row];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return self.orphanedAsds ? [self.orphanedAsds count] : 0;
}

- (void)addOrphanedAsd:(NSString *)filename libraryPath:(NSString *)libraryPath {
  [self.orphanedAsds addObject:filename];
  [self.displayNames addObject:[filename substringFromIndex:libraryPath.length]];
}

- (void)removeFile:(NSString *)filename {
  for(NSUInteger i = 0; i < [self.orphanedAsds count]; i++) {
    if([[self.orphanedAsds objectAtIndex:i] isEqualToString:filename]) {
      [self.orphanedAsds removeObjectAtIndex:i];
      [self.displayNames removeObjectAtIndex:i];
    }
  }
}

- (void)clearOrphanedAsds {
  [self.orphanedAsds removeAllObjects];
  [self.displayNames removeAllObjects];
}

- (void)dealloc {
  [_orphanedAsds release];
  [_displayNames release];
  [super dealloc];
}

@end
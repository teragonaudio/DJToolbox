//
// Created by nik on 5/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "OrphanedAsdsController.h"

@interface OrphanedAsdsController ()
@property (assign, nonatomic) NSMutableArray *displayNames;
@end

@implementation OrphanedAsdsController

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
  return [self count];
}

- (NSInteger)count {
  return self.orphanedAsds ? [self.orphanedAsds count] : 0;
}

- (void)addOrphanedAsd:(NSString *)filename libraryPath:(NSString *)libraryPath {
  [self.orphanedAsds addObject:filename];
  [self.displayNames addObject:[filename substringFromIndex:libraryPath.length]];
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
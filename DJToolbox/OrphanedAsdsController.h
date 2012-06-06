//
// Created by nik on 5/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "FilePathnameProvider.h"

@interface OrphanedAsdsController : NSObject <NSTableViewDelegate, NSTableViewDataSource, FilePathnameProvider>
@property (assign, nonatomic) NSMutableArray *orphanedAsds;
@property (readonly) NSInteger count;

- (void)addOrphanedAsd:(NSString *)filename libraryPath:(NSString *)libraryPath;
- (void)clearOrphanedAsds;

@end
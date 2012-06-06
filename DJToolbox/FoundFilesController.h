//
// Created by nik on 5/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "FilePathnameProvider.h"

@interface FoundFilesController : NSObject <NSTableViewDelegate, NSTableViewDataSource, FilePathnameProvider>

- (void)addOrphanedAsd:(NSString *)filename libraryPath:(NSString *)libraryPath;
- (void)removeFile:(NSString *)filename;
- (void)clearOrphanedAsds;

@end
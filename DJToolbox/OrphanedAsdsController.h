//
// Created by nik on 5/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface OrphanedAsdsController : NSObject <NSBrowserDelegate>
@property (assign, nonatomic) NSMutableArray *orphanedAsds;
@property (readonly) NSInteger count;

- (void)addOrphanedAsd:(NSString *)filename;

@end
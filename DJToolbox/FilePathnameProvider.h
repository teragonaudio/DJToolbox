//
// Created by nik on 6/6/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


@protocol FilePathnameProvider <NSObject>
@required
- (NSString *)pathForSelectedCell:(NSTableView *)tableView;
@end
//
//  LibraryLocationProvider.h
//  DJToolbox
//
//  Created by Nik Reiman on 5/18/12.
//  Copyright (c) 2012 Teragon Audio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LibraryLocationProvider <NSObject>
@required
- (NSString *)getiTunesLibraryLocation;
@end

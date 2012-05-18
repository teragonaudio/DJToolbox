//
//  AppDelegate.h
//  DJToolbox
//
//  Created by Nik Reiman on 5/18/12.
//  Copyright (c) 2012 Teragon Audio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LibraryLocationProvider.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, LibraryLocationProvider>

@property (assign) IBOutlet NSWindow *window;

@end

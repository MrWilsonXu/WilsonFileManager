//
//  WilsonPreviewVC.h
//  WilsonFileManager
//
//  Created by Wilson on 08/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface WilsonPreviewVC : QLPreviewController

@property (strong, nonatomic) NSURL *url;

@end

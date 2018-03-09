//
//  WilsonPreviewVC.m
//  WilsonFileManager
//
//  Created by Wilson on 08/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "WilsonPreviewVC.h"

@interface WilsonPreviewVC()<QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@end

@implementation WilsonPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
}


#pragma mark - QLPreviewControllerDataSource
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.url;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController {
    return 1;
}

@end

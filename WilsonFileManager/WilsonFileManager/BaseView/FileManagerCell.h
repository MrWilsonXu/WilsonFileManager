//
//  FileManagerCell.h
//  WilsonFileManager
//
//  Created by Wilson on 07/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileManagerCell : UITableViewCell

@property (assign, nonatomic) BOOL showMore;
@property (copy, nonatomic) NSString *titleContent;
@property (copy, nonatomic) NSString *timeContent;
@property (copy, nonatomic) NSString *sizeContent;
@property (copy, nonatomic) NSString *imgStr;
@property (nonatomic, assign) NSUInteger fileNums;

@end

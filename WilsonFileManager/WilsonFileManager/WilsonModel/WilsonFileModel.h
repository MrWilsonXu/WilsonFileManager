//
//  WilsonFileModel.h
//  WilsonFileManager
//
//  Created by Wilson on 08/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WilsonFileModel : NSObject

@property (copy, nonatomic) NSString *wholePath;

@property (copy, nonatomic) NSString *fileName;

@property (copy, nonatomic) NSString *createDate;

@property (copy, nonatomic) NSString *fileSize;

@property (assign, nonatomic) WilonFileType fileType;

@property (assign, nonatomic) BOOL showDetail;

@end

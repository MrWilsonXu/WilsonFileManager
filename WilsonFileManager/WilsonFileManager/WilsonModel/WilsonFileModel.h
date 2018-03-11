//
//  WilsonFileModel.h
//  WilsonFileManager
//
//  Created by Wilson on 08/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WilsonFileModel : NSObject

@property (copy, nonatomic) NSString *upperFilePath;

@property (copy, nonatomic) NSString *handLePath;

@property (copy, nonatomic) NSString *fileName;

@property (copy, nonatomic) NSString *createDate;

@property (copy, nonatomic) NSString *fileSize;

@property (assign, nonatomic) BOOL showDetail;

@property (assign, nonatomic) WilonFileType fileType;

@property (assign, nonatomic) HandleType *handleType;

@end


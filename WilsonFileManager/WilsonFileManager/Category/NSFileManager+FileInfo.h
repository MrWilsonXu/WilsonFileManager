//
//  NSFileManager+FileInfo.h
//  WilsonFileManager
//
//  Created by Wilson on 08/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (FileInfo)

+ (BOOL)isFolderWithPath:(NSString *)path;

+ (NSArray *)subpathsOfDirectoryWithPath:(NSString *)path;
+ (NSString *)fileNameWithPath:(NSString *)path;
+ (NSString *)fileCreateTimeWithPath:(NSString *)path;
+ (NSString *)fileSizeWithPath:(NSString *)path;
+ (NSString *)upperFilePathWithPath:(NSString *)path;
+ (WilonFileType)fileTypeWithPath:(NSString *)path;
+ (NSString *)fileAtDocumentDirectoryPathName:(NSString *)pathName;

+ (BOOL)deleteSuccessFileAtPath:(NSString *)path;

@end

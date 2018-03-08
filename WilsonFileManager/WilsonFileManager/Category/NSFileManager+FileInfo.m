//
//  NSFileManager+FileInfo.m
//  WilsonFileManager
//
//  Created by Wilson on 08/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "NSFileManager+FileInfo.h"

@implementation NSFileManager (FileInfo)

#pragma mark - Public

+ (NSArray *)subpathsOfDirectoryWithPath:(NSString *)path {
    if ([[self defaultManager] fileExistsAtPath:path]) {
        NSArray *subPaths = [[self defaultManager] contentsOfDirectoryAtPath:path error:nil];
        return subPaths;
    }
    return nil;
}

+ (NSString *)fileNameWithPath:(NSString *)path {
    return [path lastPathComponent];
}

+ (NSString *)fileSizeWithPath:(NSString *)path {
    if ([[self defaultManager] fileExistsAtPath:path]) {
        id size = [self valueForkey:NSFileSize FilePath:path];
        if ([size isKindOfClass:[NSNumber class]]) {
            return [self sizeFormatted:size];
        }
    }
    return [self emptyContent];
}

+ (NSString *)fileCreateTimeWithPath:(NSString *)path {
    if ([[self defaultManager] fileExistsAtPath:path]) {
        id dateStr = [self valueForkey:NSFileCreationDate FilePath:path];
        if ([dateStr isKindOfClass:[NSDate class]]) {
            NSDate *date = (NSDate *)dateStr;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *createDate = [dateFormatter stringFromDate:date];
            return createDate;
        }
    }
    return [self emptyContent];
}

/**
 *  NSFileTypeDirectory;
 *  NSFileTypeRegular;
 *  NSFileTypeSymbolicLink;
 *  NSFileTypeSocket;
 *  NSFileTypeCharacterSpecial;
 *  NSFileTypeBlockSpecial;
 *  NSFileTypeUnknown;
 */
+ (WilonFileType)fileTypeWithPath:(NSString *)path {
    if ([[self defaultManager] fileExistsAtPath:path]) {
        NSString *extra = path.lastPathComponent;
        NSString *type = extra.pathExtension;
        return [self fileTypeWithSuffix:type];
    }
    return WilonFileTypeDocument;
}

+ (BOOL)isFolderWithPath:(NSString *)path {
    BOOL isDir;
    [[self defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    return isDir;
}

#pragma mark - Public

+ (NSString *)emptyContent {
    return @"文件不存在";
}

+ (id)valueForkey:(NSString *)key FilePath:(NSString *)path {
    NSDictionary *dict = [[self defaultManager] attributesOfItemAtPath:path error:nil];
    NSString *value = [dict objectForKey:key];
    return value;
}

+ (NSString *)sizeFormatted:(NSNumber *)size {

    double convertedValue = [size doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = @[@"B", @"KB", @"MB", @"GB", @"TB"];
    
    while(convertedValue > 1024){
        convertedValue /= 1024;
        
        multiplyFactor++;
    }
    
    NSString *sizeFormat = ((multiplyFactor > 1) ? @"%.f %@" : @"%.0f %@");
    return [NSString stringWithFormat:sizeFormat, convertedValue, tokens[multiplyFactor]];
}

+ (WilonFileType)fileTypeWithSuffix:(NSString *)suffix {
    NSString *upper = [suffix uppercaseString];
    
    if ([upper isEqualToString:@"MP4"]  ||
        [upper isEqualToString:@"RMVB"] ||
        [upper isEqualToString:@"MKV"]  ||
        [upper isEqualToString:@"AVI"]  ||
        [upper isEqualToString:@"VIDEO"]||
        [upper isEqualToString:@"MOV"] ||
        [upper isEqualToString:@"3GP"] ||
        [upper isEqualToString:@"WMV"] ||
        [upper isEqualToString:@"RM"]  ||
        [upper isEqualToString:@"FLV"]) {
        
        return WilonFileTypeVideo;
        
    } else if ( [upper isEqualToString:@"PNG"] ||
               [upper isEqualToString:@"JPG"]  ||
               [upper isEqualToString:@"GIF"]  ||
               [upper isEqualToString:@"JPEG"] ||
               [upper isEqualToString:@"WEBP"] ) {
        
        return WilonFileTypeImage;
        
    } else if ( [upper isEqualToString:@"AI"] ||
               [upper isEqualToString:@"CSV"] ||
               [upper isEqualToString:@"EPS"] ||
               [upper isEqualToString:@"EXE"] ||
               [upper isEqualToString:@"FLASH"] ||
               [upper isEqualToString:@"HTML"] ) {
        
        return WilonFileTypeUrl;
        
    } else if ([upper isEqualToString:@"MP3"] ||
               [upper isEqualToString:@"WMA"] ||
               [upper isEqualToString:@"AAC"] ||
               [upper isEqualToString:@"AMR"] ||
               [upper isEqualToString:@"CAF"] ||
               [upper isEqualToString:@"WAVE"] ||
               [upper isEqualToString:@"AIFF"] ) {
        
         return WilonFileTypeAudio;
        
    } else if ([upper isEqualToString:@"AAC"] ||
               [upper isEqualToString:@"DOC"] ||
               [upper isEqualToString:@"DOCX"] ||
               [upper isEqualToString:@"KEYNOTE"] ||
               [upper isEqualToString:@"PAGES"] ||
               [upper isEqualToString:@"PPT"] ||
               [upper isEqualToString:@"PSD"] ||
               [upper isEqualToString:@"RTF"] ||
               [upper isEqualToString:@"SILDE"] ||
               [upper isEqualToString:@"PDF"]  ||
               [upper isEqualToString:@"TEX"]  ||
               [upper isEqualToString:@"VISIO"] ||
               [upper isEqualToString:@"WEBEX"] ||
               [upper isEqualToString:@"XML"]) {
        
        return WilonFileTypeDocument;
        
    } else if (upper.length == 0) {
       
        return WilonFileTypeFolder;
        
    }
    
    return WilonFileTypeDocument;
}

@end

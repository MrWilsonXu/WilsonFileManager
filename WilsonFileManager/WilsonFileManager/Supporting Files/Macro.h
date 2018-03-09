//
//  Macro.h
//  WilsonFileManager
//
//  Created by Wilson on 07/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define kTitleColor             [UIColor ColorWithHex:@"240603"]
#define kSubTitleColor          [UIColor ColorWithHex:@"929292"]
#define kTitleFont              [UIFont systemFontOfSize:16];
#define kSubTitleFont           [UIFont systemFontOfSize:14];

typedef NS_ENUM(NSUInteger, WilonFileType) {
    WilonFileTypeAudio = 0,
    WilonFileTypeVideo = 5,
    WilonFileTypeImage = 10,
    WilonFileTypeFolder = 15,
    WilonFileTypeDocument = 20,
    WilonFileTypeUrl =25
};

typedef NS_ENUM(NSUInteger, HandleType) {
    HandleUPLOAD = 0,
    HandleMOVE = 1,
    HandleDELETE = 2,
    HandleCREATE = 3
};

#endif /* Macro_h */

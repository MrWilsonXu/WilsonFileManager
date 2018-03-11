//
//  WilsonWebServer.h
//  WilsonFileManager
//
//  Created by Wilson on 08/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WilsonFileModel.h"

@protocol WilsonWebServerDelegate;

@interface WilsonWebServer : NSObject

/**
 *  current handle model
 */
@property (strong, nonatomic) WilsonFileModel *handleModel;

+ (instancetype)sharedManager;
- (void)initWebServerMainFilePath:(NSString *)mainFilePath;
- (void)webServerStart;
- (void)webServerStop;
- (void)webServerLoadPathData;

@property (copy, nonatomic) NSString *filePath;
@property (assign, nonatomic) BOOL hasStart;
@property (weak, nonatomic) id<WilsonWebServerDelegate> delegate;

@end

@protocol WilsonWebServerDelegate <NSObject>

- (void)webServerDataSource:(NSMutableArray <WilsonFileModel *> *)dataSource;

- (void)webServerIpAdress:(NSString *)ipAdress;

@end

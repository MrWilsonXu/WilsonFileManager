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

+ (instancetype)sharedManager;
- (void)initWebServerMainFilePath:(NSString *)mainFilePath;
- (void)webServerStart;
- (void)webServerStop;
- (void)webServerLoadData;

@property (copy, nonatomic) NSString *filePath;
@property (assign, nonatomic) BOOL hasStart;
@property (weak, nonatomic) id<WilsonWebServerDelegate> delegate;

@end

@protocol WilsonWebServerDelegate <NSObject>

- (void)webServerDataSource:(NSMutableArray <WilsonFileModel *> *)dataSource filePath:(NSString *)filePath;

- (void)webServerHandleModel:(WilsonFileModel *)model handleType:(HandleType)handleType filePath:(NSString *)filePath;

- (void)webServerIpAdress:(NSString *)ipAdress;

@end

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
- (void)initWilsonWebServerDelegateObj:(id)delegateObj mainFilePath:(NSString *)mainFilePath;
- (void)webServerStart;
- (void)webServerStop;

@property (copy, nonatomic) NSString *filePath;
@property (assign, nonatomic) BOOL hasStart;

@end

@protocol WilsonWebServerDelegate <NSObject>

- (void)webServerDataSource:(NSMutableArray <WilsonFileModel *> *)dataSource;

- (void)webServerIpAdress:(NSString *)ipAdress;

@end

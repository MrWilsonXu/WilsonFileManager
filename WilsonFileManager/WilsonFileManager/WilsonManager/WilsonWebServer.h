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
- (void)initWilsonWebServerDelegateObj:(id)delegateObj fileName:(NSString *)fileName;
- (void)webServerStart;
- (void)webServerStop;

@end

@protocol WilsonWebServerDelegate <NSObject>

- (void)webServerDataSource:(NSMutableArray <WilsonFileModel *> *)dataSource;

- (void)webServerIpAdress:(NSString *)ipAdress;

@end

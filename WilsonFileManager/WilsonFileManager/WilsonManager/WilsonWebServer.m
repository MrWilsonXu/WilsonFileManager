//
//  WilsonWebServer.m
//  WilsonFileManager
//
//  Created by Wilson on 08/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "WilsonWebServer.h"
#import "GCDWebUploader.h"
#import "NSFileManager+FileInfo.h"

typedef NS_ENUM(NSUInteger, HandleType) {
    HandleUPLOAD = 0,
    HandleMOVE = 1,
    HandleDELETE = 2,
    HandleCREATE = 3
};

@interface WilsonWebServer()<GCDWebUploaderDelegate>

@property (strong, nonatomic) GCDWebUploader *webServer;
@property (weak, nonatomic) id<WilsonWebServerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray <WilsonFileModel *> *dataSource;

@end

@implementation WilsonWebServer

- (void)dealloc {
    NSLog(@"WilsonWebServer -> dealloc");
}

static WilsonWebServer *_wilsonWebServe = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _wilsonWebServe = [[WilsonWebServer alloc] init];
    });
    return _wilsonWebServe;
}

#pragma mark - Public

- (void)initWilsonWebServerDelegateObj:(id)delegateObj mainFilePath:(NSString *)mainFilePath {
    self.delegate = delegateObj;
    self.webServer = [[GCDWebUploader alloc] initWithUploadDirectory:mainFilePath];
    self.webServer.delegate = self;
    self.webServer.allowHiddenItems = YES;
    
    NSLog(@"MainPath = %@",mainFilePath);
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initWebServerData];
    });
}

- (void)webServerStart {
    [self.webServer start];
    self.hasStart = YES;
    
    NSString *adress = [NSString stringWithFormat:NSLocalizedString(@"GCDWebServer running locally on port：\n%@", nil), self.webServer.serverURL.absoluteString];
    if ([self.delegate respondsToSelector:@selector(webServerIpAdress:)]) {
        [self.delegate webServerIpAdress:self.webServer.serverURL.absoluteString];
    }
    NSLog(@"%@",adress);
}

- (void)webServerStop {
    [self.webServer stop];
    self.webServer = nil;
    self.hasStart = NO;
}

#pragma mark - DataSource

- (void)initWebServerData {
    NSArray *subPaths = [NSFileManager subpathsOfDirectoryWithPath:self.filePath];
    if (subPaths.count > 0) {
        for (NSString *subPath in subPaths) {
            NSString *fullPath = [self.webServer.uploadDirectory stringByAppendingPathComponent:subPath];
            [self webCreateOrUpdateWithPath:fullPath handleType:HandleUPLOAD];
        }
    }
}

- (void)webCreateOrUpdateWithPath:(NSString *)path handleType:(HandleType)handleType {
    
    NSString *key = [NSFileManager fileNameWithPath:path];
    
    if (handleType == HandleMOVE) {
        
    } else if (handleType == HandleDELETE) {
        WilsonFileModel *model = [self queryFileModelWithKey:key];
        if (model) {
            [self.dataSource removeObject:model];
            [self sendDelegate];
        }
    } else {
        WilsonFileModel *model = [self fileModelWithPath:path];
        if (model) {
            [self.dataSource addObject:model];
            [self sendDelegate];
        }
    }
    
}

- (void)sendDelegate {
    if ([self.delegate respondsToSelector:@selector(webServerDataSource:)]) {
        [self.delegate webServerDataSource:self.dataSource];
    }
}

- (WilsonFileModel *)queryFileModelWithKey:(NSString *)key {
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"fileName = %@",key];
    NSArray *results = [self.dataSource filteredArrayUsingPredicate:predict];
    if (results.count > 0) {
        WilsonFileModel *model = results.firstObject;
        return model;
    }
    
    return nil;
}

- (WilsonFileModel *)fileModelWithPath:(NSString *)path {
    WilsonFileModel *model = [[WilsonFileModel alloc] init];
    model.wholePath = path;
    model.fileName = [NSFileManager fileNameWithPath:path];
    model.fileSize = [NSFileManager fileSizeWithPath:path];
    model.fileType = [NSFileManager fileTypeWithPath:path];
    model.createDate = [NSFileManager fileCreateTimeWithPath:path];
    return model;
}

#pragma mark - GCDWebUploaderDelegate

- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    NSLog(@"[UPLOAD] %@", path);
    [self webCreateOrUpdateWithPath:path handleType:HandleUPLOAD];
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSLog(@"[MOVE] %@ -> %@", fromPath, toPath);
    [self webCreateOrUpdateWithPath:toPath handleType:HandleUPLOAD];
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    NSLog(@"[DELETE] %@", path);
    [self webCreateOrUpdateWithPath:path handleType:HandleDELETE];
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    NSLog(@"[CREATE] %@", path);
    [self webCreateOrUpdateWithPath:path handleType:HandleCREATE];
}

#pragma mark - Getter

- (NSMutableArray<WilsonFileModel *> *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray <WilsonFileModel *> array];
    }
    return _dataSource;
}

@end

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

@interface WilsonWebServer()<GCDWebUploaderDelegate>

@property (strong, nonatomic) GCDWebUploader *webServer;

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

- (void)initWebServerMainFilePath:(NSString *)mainFilePath {
    self.webServer = [[GCDWebUploader alloc] initWithUploadDirectory:mainFilePath];
    self.webServer.delegate = self;
    self.webServer.allowHiddenItems = YES;
    
    NSLog(@"MainPath = %@",mainFilePath);
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
}

- (void)webServerLoadData {
    NSMutableArray *arr = [self filePathDataSource];
    
    if ([self.delegate respondsToSelector:@selector(webServerDataSource:filePath:)]) {
        [self.delegate webServerDataSource:arr filePath:self.filePath];
    }
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

- (NSMutableArray <WilsonFileModel *> *)filePathDataSource {
    NSArray *subPaths = [NSFileManager subpathsOfDirectoryWithPath:self.filePath];
    NSMutableArray *arr = [NSMutableArray <WilsonFileModel *> array];
    
    if (subPaths.count > 0) {
        for (NSString *subPath in subPaths) {
            NSString *fullPath = [self.filePath stringByAppendingPathComponent:subPath];
            WilsonFileModel *model = [self fileModelWithPath:fullPath];
            [arr addObject:model];
        }
    }
    return arr;
}


- (void)webCreateOrUpdateWithPath:(NSString *)path handleType:(HandleType)handleType  {
    
    NSString *key = [NSFileManager fileNameWithPath:path];
    WilsonFileModel *model;
    
    if (handleType == HandleMOVE) {
        
    } else if (handleType == HandleDELETE) {
        model = [self queryFileModelWithKey:key];
    } else {
        model = [self fileModelWithPath:path];
    }
    
    if ([self.delegate respondsToSelector:@selector(webServerHandleModel:handleType:filePath:)]) {
        [self.delegate webServerHandleModel:model handleType:handleType filePath:self.filePath];
    }
}


- (WilsonFileModel *)queryFileModelWithKey:(NSString *)key {
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"fileName = %@",key];
    NSArray *results = [[self filePathDataSource] filteredArrayUsingPredicate:predict];
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

@end

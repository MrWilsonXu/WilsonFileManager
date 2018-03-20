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

- (void)webServerLoadPathData {
    NSMutableArray *arr = [self filePathDataSource];
    
    if ([self.delegate respondsToSelector:@selector(webServerDataSource:)]) {
        [self.delegate webServerDataSource:arr];
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
            WilsonFileModel *model = [self fileModelWithHandelPath:fullPath handleType:HandleUPLOAD];
            [arr addObject:model];
        }
    }
    return arr;
}


- (void)webCreateOrUpdateWithHandlePath:(NSString *)handlePath handleType:(HandleType)handleType  {
    
    WilsonFileModel *model;
    
    if (handleType == HandleMOVE) {
        
    } else if (handleType == HandleDELETE) {
        model = [self fileModelWithHandelPath:handlePath handleType:handleType];
    } else {
        model = [self fileModelWithHandelPath:handlePath handleType:handleType];
    }
    
    self.handleModel = model;
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

- (WilsonFileModel *)fileModelWithHandelPath:(NSString *)handlePath handleType:(HandleType)handleType {
    WilsonFileModel *model = [[WilsonFileModel alloc] init];
    model.handLePath = handlePath;
    model.handleType = handleType;
    model.upperFilePath = [NSFileManager upperFilePathWithPath:handlePath];
    model.fileName = [NSFileManager fileNameWithPath:handlePath];
    model.fileSize = [NSFileManager fileSizeWithPath:handlePath];
    model.fileType = [NSFileManager fileTypeWithPath:handlePath];
    model.createDate = [NSFileManager fileCreateTimeWithPath:handlePath];
    model.fileNums = [NSFileManager subpathsOfDirectoryWithPath:handlePath].count;
    return model;
}

#pragma mark - GCDWebUploaderDelegate

- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    NSLog(@"[UPLOAD] %@", path);
    [self webCreateOrUpdateWithHandlePath:path handleType:HandleUPLOAD];
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSLog(@"[MOVE] %@ -> %@", fromPath, toPath);
    [self webCreateOrUpdateWithHandlePath:toPath handleType:HandleUPLOAD];
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    NSLog(@"[DELETE] %@", path);
    [self webCreateOrUpdateWithHandlePath:path handleType:HandleDELETE];
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    NSLog(@"[CREATE] %@", path);
    [self webCreateOrUpdateWithHandlePath:path handleType:HandleCREATE];
}

@end

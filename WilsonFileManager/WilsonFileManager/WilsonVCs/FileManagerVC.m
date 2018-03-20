//
//  FileManagerVC.m
//  WilsonFileManager
//
//  Created by Wilson on 07/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "FileManagerVC.h"
#import "WilsonPreviewVC.h"
#import "WilsonWebVC.h"

#import "FileManagerCell.h"
#import "WilsonWebServer.h"
#import "WilsonFileModel.h"

#import "NSFileManager+FileInfo.h"

@interface FileManagerVC ()<UITableViewDelegate, UITableViewDataSource, WilsonWebServerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UILabel *IPAdress;

@property (strong, nonatomic) WilsonFileModel *handleModel;

@property (strong, nonatomic) NSMutableArray <WilsonFileModel *> *dataSource;

@end

#define CellReuse @"FileManagerCellReuse"
#define ObserverKeyPath @"handleModel"

@implementation FileManagerVC

- (void)dealloc {
    NSLog(@"FileManagerVC -> dealloc");
    [[WilsonWebServer sharedManager] removeObserver:self forKeyPath:ObserverKeyPath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"File Manager";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.IPAdress];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.IPAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    WilsonWebServer *webServer = [WilsonWebServer sharedManager];
    webServer.delegate = self;
    NSString *mainFilePath = [NSFileManager fileAtDocumentDirectoryPathName:@"Wilson"];
    
    if (!webServer.hasStart) {
        [webServer initWebServerMainFilePath:mainFilePath];
        [webServer webServerStart];
    }
    
    if (self.filePath.length > 0) {
        webServer.filePath = self.filePath;
    } else {
        webServer.filePath = mainFilePath;
        self.filePath = mainFilePath;
    }

    self.handleModel = webServer.handleModel;
    
    // iOS 设计模式思考：多个vc或对象监听单例中某个值的改变
    [webServer addObserver:self forKeyPath:ObserverKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    [webServer webServerLoadPathData];
}

#pragma mark - Oberver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:ObserverKeyPath] && [object isKindOfClass:[WilsonWebServer class]]) {
        WilsonFileModel *model = (WilsonFileModel *)[change objectForKey:NSKeyValueChangeNewKey];
        [self updateDataSouceWithFileModel:model];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)updateDataSouceWithFileModel:(WilsonFileModel *)fileModel {
    
    if ([self currentPathWithUpperFilePath:fileModel.upperFilePath]) {
        
        if (fileModel.handleType == HandleDELETE) {
            
            WilsonFileModel *queryModel = [self queryModelWithPath:fileModel.handLePath];
            if (queryModel) {
                [self.dataSource removeObject:queryModel];
            }
            
        } else if (fileModel.handleType == HandleMOVE) {
            
        } else {
            if (fileModel) {
                [self.dataSource addObject:fileModel];
            }
        }
        
        [self.tableView reloadData];
    }
    
}

/**
 *  操作文件是否在当前vc目录下
 */
- (BOOL)currentPathWithUpperFilePath:(NSString *)upperFilePath {
    if ([self.filePath isEqualToString:upperFilePath]) {
        return YES;
    }
    return NO;
}

- (WilsonFileModel *)queryModelWithPath:(NSString *)path {
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"handLePath = %@",path];
    NSArray *results = [self.dataSource filteredArrayUsingPredicate:predict];
    if (results.count > 0) {
        WilsonFileModel *model = results.firstObject;
        return model;
    }
    
    return nil;
}

#pragma mark - WilsonWebServerDelegate

- (void)webServerDataSource:(NSMutableArray <WilsonFileModel *> *)dataSource {
    
    self.dataSource = [NSMutableArray array];
    for (WilsonFileModel *model in dataSource) {
        [self.dataSource addObject:model];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

- (void)webServerIpAdress:(NSString *)ipAdress {
    self.IPAdress.text = ipAdress;
}

#pragma mark - UITableView Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WilsonFileModel *model = self.dataSource[indexPath.row];
    
    FileManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuse];
    cell.titleContent = model.fileName;
    cell.timeContent = model.createDate;
    cell.sizeContent = model.fileSize;
    if (model.fileNums > 0) {
        cell.fileNums = model.fileNums;
    }
    
    NSString *imgStr;
    if (model.fileType == WilonFileTypeFolder) {
        imgStr = @"ico_floder";
    } else if (model.fileType == WilonFileTypeImage) {
        imgStr = @"ico_img";
    } else if (model.fileType == WilonFileTypeAudio) {
        imgStr = @"ico_audio";
    } else if (model.fileType == WilonFileTypeVideo) {
        imgStr = @"ico_video";
    } else if (model.fileType == WilonFileTypeDocument) {
        imgStr = @"ico_document";
    } else if (model.fileType == WilonFileTypeUrl) {
        imgStr = @"ico_url";
    }
        
    cell.imgStr = imgStr;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WilsonFileModel *model = self.dataSource[indexPath.row];
    NSURL *url = [NSURL fileURLWithPath:model.handLePath];

    if (model.fileType == WilonFileTypeDocument || model.fileType == WilonFileTypeImage) {
        WilsonPreviewVC *vc = [[WilsonPreviewVC alloc] init];
        vc.url = url;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.fileType == WilonFileTypeFolder) {
        FileManagerVC *vc = [[FileManagerVC alloc] init];
        vc.filePath = model.handLePath;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        WilsonWebVC *webVC = [[WilsonWebVC alloc] init];
        webVC.webUrl = url;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WilsonFileModel *model = self.dataSource[indexPath.row];
        if ([NSFileManager deleteSuccessFileAtPath:model.handLePath]) {
            [self.dataSource removeObject:model];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[FileManagerCell class] forCellReuseIdentifier:CellReuse];
    }
    return _tableView;
}

- (UILabel *)IPAdress {
    if (!_IPAdress) {
        self.IPAdress = [[UILabel alloc] init];
        _IPAdress.textColor = kTitleColor;
        _IPAdress.font = kTitleFont;
    }
    return _IPAdress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

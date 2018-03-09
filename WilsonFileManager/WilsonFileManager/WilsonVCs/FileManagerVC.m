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

@property (strong, nonatomic) NSMutableArray <WilsonFileModel *> *dataSource;

@end

#define CellReuse @"FileManagerCellReuse"
@implementation FileManagerVC

- (void)dealloc {
    NSLog(@"FileManagerVC -> dealloc");
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

     [[WilsonWebServer sharedManager] webServerLoadData];
}

#pragma mark - WilsonWebServerDelegate

- (void)webServerDataSource:(NSMutableArray <WilsonFileModel *> *)dataSource filePath:(NSString *)filePath {
    
    if ([self.filePath isEqualToString:filePath]) {
        self.dataSource = [NSMutableArray array];
        for (WilsonFileModel *model in dataSource) {
            [self.dataSource addObject:model];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)webServerHandleModel:(WilsonFileModel *)model handleType:(HandleType)handleType filePath:(NSString *)filePath {
    
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
    cell.imgStr = @"audio_cover";
    cell.sizeContent = model.fileSize;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WilsonFileModel *model = self.dataSource[indexPath.row];
    NSURL *url = [NSURL fileURLWithPath:model.wholePath];

    if (model.fileType == WilonFileTypeDocument || model.fileType == WilonFileTypeImage) {
        WilsonPreviewVC *vc = [[WilsonPreviewVC alloc] init];
        vc.url = url;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.fileType == WilonFileTypeFolder) {
        FileManagerVC *vc = [[FileManagerVC alloc] init];
        vc.filePath = model.wholePath;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        WilsonWebVC *webVC = [[WilsonWebVC alloc] init];
        webVC.webUrl = url;
        [self.navigationController pushViewController:webVC animated:YES];
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

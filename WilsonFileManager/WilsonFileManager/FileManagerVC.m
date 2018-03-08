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

@interface FileManagerVC ()<UITableViewDelegate, UITableViewDataSource, WilsonWebServerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UILabel *IPAdress;

@property (strong, nonatomic) WilsonWebServer *webServer;

@property (strong, nonatomic) NSMutableArray <WilsonFileModel *> *dataSource;

@end

#define CellReuse @"FileManagerCellReuse"
@implementation FileManagerVC

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
    
    [self.tableView reloadData];
    
    self.webServer = [WilsonWebServer sharedManager];
    [self.webServer initWilsonWebServerDelegateObj:self fileName:@"Wilson"];
    [self.webServer webServerStart];
}

#pragma mark - WilsonWebServerDelegate

- (void)webServerDataSource:(NSMutableArray <WilsonFileModel *> *)dataSource {
    self.dataSource = [NSMutableArray arrayWithArray:dataSource];
    [self.tableView reloadData];
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
        
    } else {
        WilsonWebVC *webVC = [[WilsonWebVC alloc] init];
        webVC.webUrl = url;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[FileManagerCell class] forCellReuseIdentifier:CellReuse];
    }
    return _tableView;
}

- (NSMutableArray<WilsonFileModel *> *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray <WilsonFileModel *> array];
    }
    return _dataSource;
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

//
//  FileManagerCell.m
//  WilsonFileManager
//
//  Created by Wilson on 07/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "FileManagerCell.h"

@interface FileManagerCell()

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *fileSizeLab;
@property (strong, nonatomic) UIImageView *moreImgView;

@end

@implementation FileManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self customSubviews];
    }
    return self;
}

#pragma mark - Public

- (void)setTitleContent:(NSString *)titleContent {
    _titleContent = titleContent;
    self.titleLab.text = _titleContent;
}

- (void)setTimeContent:(NSString *)timeContent {
    _timeContent = timeContent;
    self.timeLab.text = _timeContent;
}

- (void)setSizeContent:(NSString *)sizeContent {
    _sizeContent = sizeContent;
    self.fileSizeLab.text = _sizeContent;
}

- (void)setImgStr:(NSString *)imgStr {
    _imgStr = imgStr;
    if (_imgStr) {
        self.imgView.image = [UIImage imageNamed:_imgStr];
    }
}

#pragma mark - View

- (void)customSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.fileSizeLab];
    [self.contentView addSubview:self.moreImgView];
    
    [self layoutCustomViews];
}

- (void)layoutCustomViews {
    __block CGFloat margin = 15;
    CGFloat imgViewWidthHeight = 50;
    
    [self.moreImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-margin);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(margin);
        make.width.height.mas_equalTo(imgViewWidthHeight);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(margin);
        make.left.equalTo(self.imgView.mas_right).offset(8);
        make.right.equalTo(self.moreImgView.mas_left).offset(5);
    }];
    
    [self.fileSizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.width.mas_equalTo(60);
        make.right.equalTo(self.moreImgView.mas_left).offset(5);
        make.height.mas_equalTo(15);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.left.equalTo(self.imgView.mas_right).offset(5);
        make.right.equalTo(self.moreImgView.mas_left).offset(5);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(-margin);
    }];
}

#pragma mark - rotate row

- (void)tapArrowImgView:(UITapGestureRecognizer *)gesture {
    self.showMore = !self.showMore;
    [self setRightImgViewIsActive:self.showMore];
}

- (void)setRightImgViewIsActive:(BOOL)isActive {
    if (isActive) {
        [self rotateArrow:M_PI];
    } else {
        [self rotateArrow:0];
    }
}

- (void)rotateArrow:(float)degrees {
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.moreImgView.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}

#pragma mark - Getter

- (UIImageView *)imgView {
    if (!_imgView) {
        self.imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        self.titleLab = [[UILabel alloc] init];
        _titleLab.font = kTitleFont;
        _titleLab.textColor = kTitleColor;
        _titleLab.numberOfLines = 0;
        _titleLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        self.timeLab = [[UILabel alloc] init];
        _timeLab.font = kSubTitleFont;
        _timeLab.textColor = kSubTitleColor;
    }
    return _timeLab;
}

- (UILabel *)fileSizeLab {
    if (!_fileSizeLab) {
        self.fileSizeLab = [[UILabel alloc] init];
        _fileSizeLab.font = kSubTitleFont;
        _fileSizeLab.textColor = kSubTitleColor;
        [_fileSizeLab sizeToFit];
    }
    return _fileSizeLab;
}

- (UIImageView *)moreImgView {
    if (!_moreImgView) {
        self.moreImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_down"]];
        _moreImgView.contentMode = UIViewContentModeScaleAspectFit;
        _moreImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapArrowImgView:)];
        [_moreImgView addGestureRecognizer:tap];
    }
    return _moreImgView;
}

@end

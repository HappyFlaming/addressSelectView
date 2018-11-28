//
//  BB_SelectAddressView.m
//  AddressSelect
//
//  Created by gyx on 2018/11/26.
//  Copyright © 2018 Bear. All rights reserved.
//

#import "BB_SelectAddressView.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define Scale(a) (ScreenWidth/375)*a

@interface BB_SelectAddressView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView*             backgroundView;
@property (nonatomic,strong) UIView*             viewsBackView;
@property (nonatomic,strong) UIButton*           cancelBtn;

@property (nonatomic,strong) NSArray*            dataArr;//省

@property (nonatomic,strong) UITableView*        tableView;

@property (nonatomic,strong) UIButton*           provinceBtn;//省
@property (nonatomic,strong) UIButton*           cityBtn;//市
@property (nonatomic,strong) UIButton*           areaBtn;//区

@property (nonatomic,strong) UIView*             lineView;

@property (nonatomic)        UIButton*           selectBtn;//点击选中的是省、市、区
@property (nonatomic,strong) NSMutableArray*     selectIndexArr;//选中的省、市、区的数组

@end

@implementation BB_SelectAddressView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.backgroundView];
        
        [self addSubview:self.viewsBackView];
    }
    return self;
}

- (UIView *)viewsBackView {
    if (!_viewsBackView) {
        _viewsBackView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-Scale(368), ScreenWidth, Scale(368))];
        _viewsBackView.backgroundColor = [UIColor whiteColor];
        
        [_viewsBackView addSubview:self.cancelBtn];
        
        [_viewsBackView addSubview:self.provinceBtn];
        
        [_viewsBackView addSubview:self.cityBtn];
        
        [_viewsBackView addSubview:self.areaBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Scale(41), ScreenWidth, 1)];
        lineView.backgroundColor = UIColor.blackColor;
        [_viewsBackView addSubview:lineView];
        
        [_viewsBackView addSubview:self.lineView];
        
        _selectBtn = _provinceBtn;
        
        [_viewsBackView addSubview:self.tableView];
    }
    return _viewsBackView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(ScreenWidth-Scale(50), Scale(10.5), Scale(40), Scale(20));
        [_cancelBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:Scale(15)];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:@"确认" forState:UIControlStateSelected];
    }
    return _cancelBtn;
}

- (void)cancelBtnClick:(UIButton*)btn {
    if (btn.selected) {
        if (_addressBlock) {
            _addressBlock([NSString stringWithFormat:@"%@ %@ %@",_provinceBtn.titleLabel.text,_cityBtn.isHidden?@"":_cityBtn.titleLabel.text,_areaBtn.isHidden?@"":_areaBtn.titleLabel.text]);
        }
    }
    [self removeFromSuperview];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.provinceBtn.frame.origin.x, Scale(39), self.provinceBtn.frame.size.width, Scale(3))];
        _lineView.backgroundColor = UIColor.orangeColor;
    }
    return _lineView;
}

- (UIButton *)areaBtn {
    if (!_areaBtn) {
        _areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _areaBtn.frame = CGRectMake(self.cityBtn.frame.origin.x+self.cityBtn.frame.size.width+Scale(10), Scale(10.5), Scale(100), Scale(20));
        [_areaBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
        _areaBtn.titleLabel.font = [UIFont systemFontOfSize:Scale(12)];
        [_areaBtn addTarget:self action:@selector(areaClick:) forControlEvents:UIControlEventTouchUpInside];
        _areaBtn.hidden = YES;
    }
    return _areaBtn;
}

- (void)areaClick:(UIButton*)btn {
    [self setLineViewState:btn];
}

- (UIButton *)cityBtn {
    if (!_cityBtn) {
        _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cityBtn.frame = CGRectMake(self.provinceBtn.frame.origin.x+self.provinceBtn.frame.size.width+Scale(10), Scale(10.5), Scale(100), Scale(20));
        [_cityBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
        _cityBtn.titleLabel.font = [UIFont systemFontOfSize:Scale(12)];
        [_cityBtn addTarget:self action:@selector(cityClick:) forControlEvents:UIControlEventTouchUpInside];
        _cityBtn.hidden = YES;
    }
    return _cityBtn;
}

- (void)cityClick:(UIButton*)btn {
    [self setLineViewState:btn];
}

- (UIButton *)provinceBtn {
    if (!_provinceBtn) {
        _provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _provinceBtn.frame = CGRectMake(Scale(10), Scale(10.5), Scale(100), Scale(20));
        [_provinceBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_provinceBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
        _provinceBtn.titleLabel.font = [UIFont systemFontOfSize:Scale(12)];
        [_provinceBtn addTarget:self action:@selector(provinceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _provinceBtn;
}

- (void)provinceClick:(UIButton*)btn {
    [self setLineViewState:btn];
}

- (void)setLineViewState:(UIButton*)btn {
    if([_selectBtn isEqual:btn])return;
    _selectBtn = btn;
    [self.tableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(btn.frame.origin.x, self.lineView.frame.origin.y, self.lineView.frame.size.width, self.lineView.frame.size.height);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Scale(42), ScreenWidth, _viewsBackView.frame.size.height-Scale(42)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_selectBtn isEqual:_cityBtn]) {
        return [self.selectIndexArr[0] count];
    }else if ([_selectBtn isEqual:_areaBtn]) {
        return [self.selectIndexArr[1] count];
    }else {
        return self.dataArr.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *text;
    if ([_selectBtn isEqual:_cityBtn]) {
        text = self.selectIndexArr[0][indexPath.row][@"name"];
    }else if ([_selectBtn isEqual:_areaBtn]) {
        text = self.selectIndexArr[1][indexPath.row];
    }else {
        text = self.dataArr[indexPath.row][@"name"];
    }
    cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_selectBtn isEqual:_provinceBtn]) {
        
        [_provinceBtn setTitle:self.dataArr[indexPath.row][@"name"] forState:UIControlStateNormal];
        [self.selectIndexArr setObject:self.dataArr[indexPath.row][@"child"] atIndexedSubscript:0];
        
        _areaBtn.hidden = YES;
        if ([self.selectIndexArr[0] count] > 0) {
            _cityBtn.hidden = NO;
            _cancelBtn.selected = NO;
            [self setLineViewState:_cityBtn];
            [_cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
        }else {
            _cancelBtn.selected = YES;
            _cityBtn.hidden = YES;
        }
        
    }else if ([_selectBtn isEqual:_cityBtn]) {
        
        [_cityBtn setTitle:self.selectIndexArr[0][indexPath.row][@"name"] forState:UIControlStateNormal];
        [self.selectIndexArr setObject:self.selectIndexArr[0][indexPath.row][@"child"] atIndexedSubscript:1];
        
        if ([self.selectIndexArr[1] count] > 0) {
            _areaBtn.hidden = NO;
            _cancelBtn.selected = NO;
            [self setLineViewState:_areaBtn];
            [_areaBtn setTitle:@"请选择" forState:UIControlStateNormal];
        }else {
            _cancelBtn.selected = YES;
            _areaBtn.hidden = YES;
        }
        
    }else if ([_selectBtn isEqual:_areaBtn]) {
        
        [self.selectIndexArr setObject:indexPath atIndexedSubscript:2];
        _cancelBtn.selected = YES;
        [_areaBtn setTitle:self.selectIndexArr[1][indexPath.row] forState:UIControlStateNormal];
    }
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.42;
    }
    return _backgroundView;
}

- (void)showView {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        //解析json文件获取省市区数组
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"geojson"];
        _dataArr = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
    }
    return _dataArr;
}

- (NSMutableArray *)selectIndexArr {
    if (!_selectIndexArr) {
        _selectIndexArr = [NSMutableArray arrayWithCapacity:2];
    }
    return _selectIndexArr;
}

@end

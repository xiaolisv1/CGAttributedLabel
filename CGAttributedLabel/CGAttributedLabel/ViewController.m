//
//  ViewController.m
//  CGAttributedLabel
//
//  Created by xiao li on 2017/8/29.
//  Copyright © 2017年 xiao li. All rights reserved.
//

#import "ViewController.h"
#import "CGAttributedLabel.h"
#import "Masonry.h"
@interface ViewController ()<CGAttributedLabelDelegate>
@property (nonatomic ,strong) CGAttributedLabel *attributedLabel;
@property (nonatomic ,strong) UIView * scrollViewContentView ;
@property (nonatomic ,strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.attributedLabel.tagString = @"[@]" ;
    self.attributedLabel.textString = @"Harvey rapidly intensified Thursday morning in the central Gulf of Mexico, and it officially became a hurricane early in the afternoon. The extremely dangerous storm is predicted to strengthen and plow into southeast Texas on Friday as the first major hurricane, [@] ,rated Category 3 or higher (on the 1-5 Saffir-Simpson intensity scale), to strike U.S. [@],soil in 12 years.、n\nAn incredible amount of rain, 15 to 25 inches with isolated amounts of up to 35 inches, [@],is predicted along the middle and upper Texas coast, because the storm is expected to stall and unload torrents for four to six straight days. The National Hurricane Center said it expects “devastating and life-threatening” flash flooding.\nMarshall Shepherd,[@], a past-president of the American Meteorological Society, tweeted that he feared an “epic flood catastrophe.\nNot only are the rain and flooding concerns huge, but the storm also has the potential to generate destructive winds and a devastating storm surge — or raise the water as much as 6 to 12 feet above normally dry land at the coast.\nIn all these years, it’s rare that I’ve seen a hurricane threat that concerns me as much as this one does,” [@],said Rick Knabb, hurricane expert at The Weather Channel and formerly the director of the National Hurricane Center." ;
    
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        [self.view addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.top.equalTo(self.view);
            
        }];
    }
    return _scrollView ;
}

-(UIView *)scrollViewContentView{
    if (!_scrollViewContentView) {
        _scrollViewContentView = [[UIView alloc] init];
        [self.scrollView addSubview:_scrollViewContentView];
        [_scrollViewContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
            make.height.greaterThanOrEqualTo(@0.f);//此处保证容器View高度的动态变化 大于等于0.f的高度
        }];
    }
    return _scrollViewContentView ;
}


-(CGAttributedLabel *)attributedLabel{
    if (!_attributedLabel) {
        _attributedLabel = [[CGAttributedLabel alloc]init];
        [self.scrollViewContentView addSubview:_attributedLabel];
        _attributedLabel.backgroundColor = [UIColor whiteColor];
        _attributedLabel.lineSpacinge = 8 ;
        _attributedLabel.bottomLineWith = 2.0 ;
        _attributedLabel.deleteLineWith = 2.0 ;
        _attributedLabel.deleteLineColor = [UIColor redColor] ;
        _attributedLabel.bottomLineColor = [UIColor blueColor] ;
        _attributedLabel.delegate = self ;
        
        [_attributedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollViewContentView.mas_top).offset(5);
            make.left.equalTo(self.scrollViewContentView.mas_left).offset(5);
            make.centerY.equalTo(self.scrollViewContentView.mas_centerY).offset(0);
            make.centerX.equalTo(self.scrollViewContentView.mas_centerX).offset(0);
            // make.height.greaterThanOrEqualTo(@16.f);
        }];
    }
    return _attributedLabel ;
}


//WXAttributedLabel代理 返回替换的字符

-(id)replaceCharactersInWXAttributedLabel:(CGAttributedLabel *)attributedLabel index:(NSInteger)index{
    if (index == 1) {
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 90, 25)];
        textField.backgroundColor = [UIColor redColor];
        return textField ;
    }
    NSString * answer = @"how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !how are you !" ;
    NSString * myanswer = @"how do you do ! yes i am no no no ." ;
    NSMutableAttributedString *answerAttributedString ;
    
    if (index % 2 == 0) {
        NSString * string = [NSString stringWithFormat:@"%@(%@)",answer,myanswer] ;
        answerAttributedString = [[NSMutableAttributedString alloc] initWithString:string] ;
        /**
         设置删除线
         */
        [answerAttributedString addAttribute:RUNATTRIBUTE_DELETE_LINE_KEY value:RUNATTRIBUTE_DELETE_LINE_VALUE range:NSMakeRange(answer.length+1, myanswer.length)] ;
        [answerAttributedString addAttribute:RUNATTRIBUTE_YESORNO_KEY value:[UIColor redColor] range:NSMakeRange(0, answerAttributedString.length)];
        [answerAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, answer.length)];
        [answerAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(answer.length +1 , myanswer.length)];
    }else{
        NSString * string = [NSString stringWithFormat:@"%@",myanswer] ;
        answerAttributedString = [[NSMutableAttributedString alloc] initWithString:string] ;
        [answerAttributedString addAttribute:RUNATTRIBUTE_YESORNO_KEY value:[UIColor greenColor] range:NSMakeRange(0, answerAttributedString.length)];
    }
    /**
     设置下划线
     */
    [answerAttributedString addAttribute:RUNATTRIBUTE_BOTTOM_LINE_KEY value:RUNATTRIBUTE_BOTTOM_LINE_VALUE range:NSMakeRange(0, answerAttributedString.length)];
    /**
     标识对错
     */
    [answerAttributedString addAttribute:RUNATTRIBUTE_BOTTOM_LINE_KEY value:RUNATTRIBUTE_BOTTOM_LINE_VALUE range:NSMakeRange(0, answerAttributedString.length)];
    [answerAttributedString addAttribute:@"2121" value:answerAttributedString.string range:NSMakeRange(0, answerAttributedString.length)];
    return answerAttributedString ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

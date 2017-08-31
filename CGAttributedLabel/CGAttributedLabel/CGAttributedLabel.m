//
//  CGAttributedLabel.m
//  CGAttributedLabel
//
//  Created by xiao li on 2017/8/31.
//  Copyright © 2017年 xiao li. All rights reserved.
//

#import "CGAttributedLabel.h"
#import <CoreText/CoreText.h>
@interface CGAttributedLabel()
@property (nonatomic ,assign)CGSize viewSize ;
@property (nonatomic ,strong)NSMutableArray * viewsArray ;
@property (nonatomic ,strong)NSMutableArray * rectssArray ;
@property (nonatomic ,assign)CGRect touchrec ;
@property (nonatomic ,copy)NSString * cilckstr ;
@end
@implementation CGAttributedLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    //x，y轴方向移动
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(context, 1.0 ,-1.0);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    CGMutablePathRef Path = CGPathCreateMutable();
    //坐标点在左下角
    CGPathAddRect(Path, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attributedText.length), Path, NULL);
    [self drawBottomLine:frame];
    
    CTFrameDraw(frame,context);
    CGPathRelease(Path);
    CFRelease(framesetter);
    
    [self drawDeleteLine:frame];
    [self drawView:frame];
    
    
    
    
    
    
}

-(void)asda{
    
}

-(void)drawView:(CTFrameRef)frame{
    NSArray * views = [self calculateImagePositionInCTFrame:frame];
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * view = _viewsArray[idx];
        CGRect rect = [obj CGRectValue];
        view.frame = CGRectMake(rect.origin.x, self.frame.size.height - rect.origin.y - rect.size.height, rect.size.width, rect.size.height) ;
        [self addSubview:view];
    }];
    
}

/**
 下划线绘制
 */
-(void)drawBottomLine:(CTFrameRef)frame {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    NSArray * bottomLineRects =  [self calculateImagePositionInCTFrame:frame runAttributesKey:RUNATTRIBUTE_BOTTOM_LINE_KEY runAttributesValue:RUNATTRIBUTE_BOTTOM_LINE_VALUE] ;
    _rectssArray = [NSMutableArray arrayWithArray:bottomLineRects];
    UIColor *lcolor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0] ;
   // UIColor *bcolor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    [bottomLineRects enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = [obj[@"r"] CGRectValue];
        CGRect bfre = [obj[@"rere"] CGRectValue] ;
        CGRect rect1 = CGRectMake(bfre.origin.x, bfre.origin.y-self.lineSpacinge, bfre.size.width, bfre.size.height+self.lineSpacinge * 2);
        if (_cilckstr != nil && [_cilckstr isEqualToString:obj[@"tag"]]) {
            
            //创建路径并获取句柄
            CGMutablePathRef path = CGPathCreateMutable();
            //将矩形添加到路径中
            CGPathAddRect(path,NULL, rect1);
            //将路径添加到上下文
            CGContextAddPath(context, path);
            //矩形边框颜色
            [lcolor setStroke];
            [lcolor setFill];
            //边框宽度
            CGContextSetLineWidth(context,1.0f);
            //绘制
            //    CGContextStrokePath(context);
            CGContextDrawPath(context, kCGPathFillStroke);
            CGPathRelease(path);
        }
        
        //设置线宽
        CGFloat width = self.bottomLineWith>0?self.bottomLineWith:1;
        CGContextSetLineWidth(context, width);
        
        UIColor * color = obj[@"c"] ;
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        
        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y-self.lineSpacinge);
        CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y-self.lineSpacinge);
        CGContextStrokePath(context);//使用当前 CGContextRef设置的线宽绘制路径
        
        
    }];
    
    
}

/**
 删除线绘制
 */
-(void)drawDeleteLine:(CTFrameRef)frame{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线宽
    CGFloat width = self.deleteLineWith>0?self.deleteLineWith:1;
    CGContextSetLineWidth(context, width);
    
    NSArray * deleteLineRects =  [self calculateImagePositionInCTFrame:frame runAttributesKey:RUNATTRIBUTE_DELETE_LINE_KEY runAttributesValue:RUNATTRIBUTE_DELETE_LINE_VALUE] ;
    
    [deleteLineRects enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = [obj[@"r"] CGRectValue];
        UIColor * color = obj[@"c"] ;
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + rect.size.height/2.0);
        CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y + rect.size.height/2.0);
        CGContextStrokePath(context);//使用当前 CGContextRef设置的线宽绘制路径
    }];
    
}

/**
 初始化
 */
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.numberOfLines = 0 ;
        self.userInteractionEnabled = YES ;
    }
    return self ;
}


/**
 获得文本数据
 */
-(void)setTextString:(NSString *)textString{
    _textString = textString ;
    // _textString sp
    /**
     解析html文本
     */
    NSMutableAttributedString * htmlAttributedString = [[NSMutableAttributedString alloc] initWithData:[_textString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    /**
     代理是否实现，如果没有设置代理，直接赋值文本
     */
    if ([self.delegate respondsToSelector:@selector(replaceCharactersInWXAttributedLabel:index:)] && self.tagString) {
        /**
         替换标识为 self.tagString
         */
        NSArray * htmlStringArray = [htmlAttributedString.string componentsSeparatedByString:self.tagString];
        
        NSMutableAttributedString *textAttributedString=[[NSMutableAttributedString alloc] init];
        /**
         对富文本进行重新组合
         */
        _viewsArray = [NSMutableArray array];
        [htmlStringArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString * idfanierStr = [NSString stringWithFormat:@"rag=%lu",(unsigned long)idx];
            
            if (idx < htmlStringArray.count-1) {
                NSMutableAttributedString * lll = [[NSMutableAttributedString alloc] initWithString:obj attributes:nil] ;
                
                [lll addAttribute:@"model" value:idfanierStr range:NSMakeRange(0, lll.length)];
                [textAttributedString appendAttributedString:lll];
                
                id obj = [self.delegate replaceCharactersInWXAttributedLabel:self index:idx];
                if ([obj isKindOfClass:[NSMutableAttributedString class]] || [obj isKindOfClass:[NSAttributedString class]]) {
                    NSMutableAttributedString * ddd = [self.delegate replaceCharactersInWXAttributedLabel:self index:idx] ;
                    [ddd addAttribute:@"model" value:idfanierStr range:NSMakeRange(0, ddd.length)];
                    [textAttributedString appendAttributedString:ddd];
                }else{
                    UIView * view = [self.delegate replaceCharactersInWXAttributedLabel:self index:idx];
                    //selfview = view ;
                    // CTRunDelegateCallbacks：一个用于保存指针的结构体，由CTRun delegate进行回调
                    CTRunDelegateCallbacks callbacks;
                    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
                    callbacks.version = kCTRunDelegateVersion1;
                    callbacks.getAscent = ascentCallback;
                    callbacks.getDescent = descentCallback;
                    callbacks.getWidth = widthCallback;
                    callbacks.dealloc  = deallocCallback;
                    
                    //    NSString * ww = [NSString stringWithFormat:@"%@",sss];
                    
                    // 设置CTRun的代理
                    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks,(__bridge void * _Nullable)(view));
                    
                    //   [textAttributedString addAttribute:(__bridge_transfer NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range: CFRangeMake(textAttributedString, 1)];
                    //run
                    unichar objectReplacementChar = 0xFFFC;
                    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
                    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content];
                    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
                    CFRelease(delegate);
                    [textAttributedString appendAttributedString:space];
                    
                    [_viewsArray addObject:view];
                }
            }else{
                [textAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:obj attributes:nil]];
            }
        }];
        
        /**
         设置间距等属性
         */
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:15.0];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [textAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textAttributedString length])];
        [textAttributedString addAttribute:NSFontAttributeName value:WXTEXTFONT range:NSMakeRange(0, textAttributedString.length)];
        self.attributedText = textAttributedString ;
    }else{
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:15.0];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [htmlAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [htmlAttributedString length])];
        [htmlAttributedString addAttribute:NSFontAttributeName value:WXTEXTFONT range:NSMakeRange(0, htmlAttributedString.length)];
        self.attributedText = htmlAttributedString ;
    }
    
}
#pragma mark - CTRun delegate 回调方法
void deallocCallback(void* refCon ){
    
    
    
}


static CGFloat ascentCallback(void *ref) {
    if ([(__bridge id)ref isKindOfClass:[UIView class]])
    {
        UIView * view = (__bridge UIView *)ref ;
        return view.frame.size.height ;
    }
    return 0;
}

static CGFloat descentCallback(void *ref) {
    
    return 0;
}

static CGFloat widthCallback(void *ref) {
    
    if ([(__bridge id)ref isKindOfClass:[UIView class]])
    {
        UIView * view = (__bridge UIView *)ref ;
        return view.frame.size.width+5000 ;
    }
    return 0;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint location = [self systemPointFromScreenPoint:[touch locationInView:self]];
    
    [self.rectssArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = [obj[@"r"] CGRectValue];
        CGRect rect1 = CGRectMake(rect.origin.x, rect.origin.y-self.lineSpacinge, rect.size.width, rect.size.height+self.lineSpacinge);
        if ([self isFrame:rect1 containsPoint:location]) {
            _touchrec = rect1 ;
            NSMutableAttributedString * add = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
            NSRange rr = [self.attributedText.string rangeOfString:obj[@"v"]] ;
            [add addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0] range:rr];
            _cilckstr = obj[@"tag"];
            self.attributedText = add ;
            NSLog(@"您点击到了下划线文字-----%@",obj[@"v"]);
            *stop = YES ;
        }
    }];
    
}

//-(void)ClickOnStrWithPoint:(CGPoint)location
//{
//    NSArray * lines = (NSArray *)CTFrameGetLines(self.data.ctFrame);
//    CFRange ranges[lines.count];
//    CGPoint origins[lines.count];
//    CTFrameGetLineOrigins(self.data.ctFrame, CFRangeMake(0, 0), origins);
//    for (int i = 0; i = range.location)) {
//        return YES;
//    }
//    return NO;
//}

-(BOOL)isFrame:(CGRect)frame containsPoint:(CGPoint)point
{
    return CGRectContainsPoint(frame, point);
}


-(CGPoint)systemPointFromScreenPoint:(CGPoint)origin
{
    return CGPointMake(origin.x, self.bounds.size.height - origin.y);
}

- (NSArray *)calculateImagePositionInCTFrame:(CTFrameRef)ctFrame {
    
    // 获得CTLine数组
    NSArray *lines = (NSArray *)CTFrameGetLines(ctFrame);
    NSInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    NSMutableArray * array = [NSMutableArray array];
    // 遍历每个CTLine
    for (NSInteger i = 0 ; i < lineCount; i++) {
        
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray *runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        
        // 遍历每个CTLine中的CTRun
        for (id runObj in runObjArray) {
            
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            
            //            NSDictionary *metaDic = CTRunDelegateGetRefCon(delegate);
            //            if (![metaDic isKindOfClass:[NSDictionary class]]) {
            //                continue;
            //            }
            
            CGRect runBounds = CGRectZero;
            CGFloat ascent = 0;
            CGFloat descent = 0;
            
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            [array addObject:[NSValue valueWithCGRect:delegateBounds]];
        }
    }
    return array;
}

/**
 查找插入属性的run 计算绘图区域
 */
- (NSArray *)calculateImagePositionInCTFrame:(CTFrameRef)ctFrame runAttributesKey:(NSString *)key runAttributesValue:(NSString *)valiue{
    
    NSMutableArray * array = [NSMutableArray array];
    // 获得CTLine数组
    NSArray *lines = (NSArray *)CTFrameGetLines(ctFrame);
    NSInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    // 遍历每个CTLine
    
    for (NSInteger i = 0 ; i < lineCount; i++) {
        
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray *runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        
        // 遍历每个CTLine中的CTRun
        for (id runObj in runObjArray) {
            
            CTRunRef run = (__bridge CTRunRef)runObj;
            
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            NSString * runValue = [runAttributes objectForKey:key];
            
            if ([runValue isEqualToString:valiue]) {
                CGRect runBounds = CGRectZero;
                CGFloat ascent = 0;
                CGFloat descent = 0;
                CGRect bgrunbouns = CGRectZero ;
                runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
                bgrunbouns.size.width = runBounds.size.width ;
                bgrunbouns.size.height = ascent - descent;
                runBounds.size.height = ascent + descent;
                
                CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                runBounds.origin.x = lineOrigins[i].x + xOffset;
                runBounds.origin.y = lineOrigins[i].y;
                bgrunbouns.origin.x = runBounds.origin.x ;
                bgrunbouns.origin.y = lineOrigins[i].y ;
                UIColor * lineColor ;
                if ([runValue isEqualToString:RUNATTRIBUTE_DELETE_LINE_VALUE]) {
                    runBounds.origin.y -= descent;
                    lineColor = self.deleteLineColor?self.deleteLineColor:[UIColor blueColor];
                }else{
                    if ([runAttributes[RUNATTRIBUTE_YESORNO_KEY] isKindOfClass:[UIColor class]]) {
                        lineColor = runAttributes[RUNATTRIBUTE_YESORNO_KEY];
                    }else{
                        lineColor = [UIColor blueColor] ;
                    }
                }
                
                CGPathRef pathRef = CTFrameGetPath(ctFrame);
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
                
                [array addObject:@{@"c":lineColor,@"r":[NSValue valueWithCGRect:delegateBounds],@"v":runAttributes[@"2121"],@"tag":runAttributes[@"model"],@"rere":[NSValue valueWithCGRect:bgrunbouns]}];
            }
            
        }
    }
    return array;
}


@end

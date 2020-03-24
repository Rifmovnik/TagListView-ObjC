//
//  TagListView.m
//  TagObjc
//
//  Created by Javi Pulido on 16/7/15.
//  Copyright (c) 2015 Javi Pulido. All rights reserved.
//

#import "TagListView.h"
#import "TagView.h"

@interface TagListView ()

@property (nonatomic) NSMutableArray<TagView*>* tagViews;
@property (nonatomic) CGFloat intrinsicContentHeight;

@end

@implementation TagListView

// Required by Interface Builder
#if TARGET_INTERFACE_BUILDER
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];  
    return self;
}
#endif

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    for(TagView *tagView in self.tagViews) {
        [tagView setTextColor:textColor];
    }
}

- (void)setTagBackgroundColor:(UIColor *)tagBackgroundColor
{
    _tagBackgroundColor = tagBackgroundColor;
    for(TagView *tagView in self.tagViews) {
        [tagView setTagBackgroundColor:tagBackgroundColor];
    }
}

- (void)setTagHighlightedBackgroundColor:(UIColor *)tagHighlightedBackgroundColor
{
    _tagHighlightedBackgroundColor = tagHighlightedBackgroundColor;
    for(TagView *tagView in self.tagViews) {
        [tagView setHighlightedBackgroundColor:tagHighlightedBackgroundColor];
    }
}

- (void)setTagSelectedBackgroundColor:(UIColor *)tagSelectedBackgroundColor
{
    _tagSelectedBackgroundColor = tagSelectedBackgroundColor;
    for(TagView *tagView in self.tagViews) {
        [tagView setSelectedBackgroundColor:tagSelectedBackgroundColor];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    for(TagView *tagView in self.tagViews) {
        [tagView setCornerRadius:cornerRadius];
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    for(TagView *tagView in self.tagViews) {
        [tagView setBorderWidth:borderWidth];
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    for(TagView *tagView in self.tagViews) {
        [tagView setBorderColor:borderColor];
    }
}

- (void)setPaddingY:(CGFloat)paddingY
{
    _paddingY = paddingY;
    for(TagView *tagView in self.tagViews) {
        [tagView setPaddingY:paddingY];
    }
}

- (void)setPaddingX:(CGFloat)paddingX
{
    _paddingX = paddingX;
    for(TagView *tagView in self.tagViews) {
        [tagView setPaddingX:paddingX];
    }
}

- (void)setMarginY:(CGFloat)marginY
{
    _marginY = marginY;
    [self rearrangeViews];
}

- (void)setMarginX:(CGFloat)marginX
{
    _marginX = marginX;
    [self rearrangeViews];
}

- (void)setAlignment:(TagListAlignment)alignment
{
    _alignment = alignment;
    [self rearrangeViews];
}

# pragma mark - Interface builder

- (void)prepareForInterfaceBuilder
{
    [self addTag:@"Thanks"];
    [self addTag:@"for"];
    [self addTag:@"using"];
    [self addTag:@"TagListView"];
}

# pragma mark - Layout

- (CGSize)sizeThatFits:(CGSize)size
{
	CGFloat height = 0;
    CGSize rowSize = CGSizeZero;
    for(TagView *tagView in self.tagViews) {
        CGSize tagSize = tagView.intrinsicContentSize;
        if(rowSize.width + tagSize.width + self.marginX > size.width - self.layoutMargins.left - self.layoutMargins.right) {
			height += rowSize.height + self.marginY;
			rowSize = CGSizeZero;
        }
		rowSize.width += tagSize.width + self.marginX;
		rowSize.height = MAX(rowSize.height, tagSize.height);
    }
	if(rowSize.height > 0) {
		height += rowSize.height + self.layoutMargins.top + self.layoutMargins.bottom;
	}
    return CGSizeMake(size.width, height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self rearrangeViews];
}

- (void)rearrangeViews
{
	CGFloat height = 0;
    CGSize rowSize = CGSizeZero;
    for(TagView *tagView in self.tagViews) {
        CGSize tagSize = tagView.intrinsicContentSize;
        if(rowSize.width + tagView.frame.size.width + self.marginX > self.frame.size.width - self.layoutMargins.left - self.layoutMargins.right) {
			height += rowSize.height + self.marginY;
			rowSize = CGSizeZero;
        }
		CGRect rect;
		rect.origin.x = rowSize.width + self.layoutMargins.left;
		rect.origin.y = height + self.layoutMargins.top;
		rect.size = tagSize;
		tagView.frame = rect;
		rowSize.width += tagSize.width + self.marginX;
		rowSize.height = MAX(rowSize.height, tagSize.height);
    }
	if(rowSize.height > 0) {
		height += rowSize.height + self.layoutMargins.top + self.layoutMargins.bottom;
	}
	self.intrinsicContentHeight = height;
    [self invalidateIntrinsicContentSize];
}

# pragma mark - Manage tags

- (CGSize) intrinsicContentSize
{
    return CGSizeMake(self.frame.size.width, self.intrinsicContentHeight);
}

- (TagView *)addTag:(NSString *)title
{
    TagView *tagView = [[TagView alloc] initWithTitle:title];
    
    [tagView setTextColor: [self textColor]];
    [tagView setTagBackgroundColor: [self tagBackgroundColor]];
    [tagView setHighlightedBackgroundColor: [self tagHighlightedBackgroundColor]];
    [tagView setSelectedBackgroundColor: [self tagSelectedBackgroundColor]];
    [tagView setCornerRadius: [self cornerRadius]];
    [tagView setBorderWidth: [self borderWidth]];
    [tagView setBorderColor: [self borderColor]];
    [tagView setPaddingY: [self paddingY]];
    [tagView setPaddingX: [self paddingX]];
    [tagView setTextFont: [self textFont]];
    
    [tagView addTarget:self action:@selector(tagPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addTagView: tagView];
    return tagView;
}

- (void) addTagView:(TagView *)tagView
{
	if(!_tagViews) {
		_tagViews = [NSMutableArray new];
	}
    [_tagViews addObject:tagView];
	[self addSubview:tagView];
    [self rearrangeViews];
}

- (void)addTagsAccordingToDataSourceArray:(NSArray<NSString *> *)dataSourceArray withOnTapForEach:(void(^)(TagView *tagView))onTapBlock
{
    for (NSString *tagName in dataSourceArray) {
        TagView *tagView = [self addTag:tagName];
		if (onTapBlock) {
            tagView.onTap = onTapBlock;
		}
    }
}

- (void)removeTag:(NSString *)title
{
    for(NSInteger index = self.tagViews.count - 1; index >= 0; index--) {
        TagView *tagView = self.tagViews[index];
        if([[tagView currentTitle] isEqualToString:title]) {
            [tagView removeFromSuperview];
            [_tagViews removeObjectAtIndex:index];
        }
    }
}

- (void)removeAllTags
{
    for(TagView *tagView in self.tagViews) {
        [tagView removeFromSuperview];
    }
	_tagViews = nil;
    [self rearrangeViews];
}

- (void)tagPressed:(TagView *)sender
{
    if(sender.onTap) {
        sender.onTap(sender);
    }
}

@end

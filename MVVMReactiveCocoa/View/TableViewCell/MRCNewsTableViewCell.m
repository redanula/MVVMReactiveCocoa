//
//  MRCNewsTableViewCell.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 15/7/5.
//  Copyright (c) 2015年 leichunfeng. All rights reserved.
//

#import "MRCNewsTableViewCell.h"
#import "MRCNewsItemViewModel.h"

@interface MRCNewsTableViewCell () <DTAttributedTextContentViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *actionImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet DTAttributedLabel *detailView;

@end

@implementation MRCNewsTableViewCell

- (void)awakeFromNib {
    self.avatarImageView.backgroundColor = HexRGB(colorI6);
    
    CGRect frame = self.detailView.frame;
    frame.size.width = SCREEN_WIDTH - 10 * 2;
    self.detailView.frame = frame;
    
    self.detailView.delegate = self;
}

- (void)bindViewModel:(MRCNewsItemViewModel *)viewModel {
    [self.avatarImageView sd_setImageWithURL:viewModel.event.actorAvatarURL];
    
    self.nameLabel.text = viewModel.event.actorLogin;
    
    self.actionImageView.image = [UIImage octicon_imageWithIcon:@"Star" backgroundColor:[UIColor clearColor] iconColor:HexRGB(0xbbbbbb) iconScale:1 andSize:self.actionImageView.frame.size];
    
    NSString *string = @"juntianzi starredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarredstarred leichunfeng/MVVMReactiveCocoa";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[string rangeOfString:string]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:HexRGB(0x4078c0) range:[string rangeOfString:@"juntianzi"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:HexRGB(0x4078c0) range:[string rangeOfString:@"leichunfeng/MVVMReactiveCocoa"]];
    [attributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"https://github.com/leichunfeng/MVVMReactiveCocoa"] range:[string rangeOfString:@"leichunfeng/MVVMReactiveCocoa"]];
    
    self.detailView.layoutFrameHeightIsConstrainedByBounds = NO;
    self.detailView.attributedString = attributedString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.detailView.frame = CGRectMake(10, 10 + 40 + 10, [self.detailView suggestedFrameSizeToFitEntireStringConstraintedToWidth:CGRectGetWidth(self.frame) - 10 * 2].width, [self.detailView suggestedFrameSizeToFitEntireStringConstraintedToWidth:SCREEN_WIDTH - 10 * 2].height);
}

- (CGFloat)height {
    return 10 + 40 + 10 + [self.detailView suggestedFrameSizeToFitEntireStringConstraintedToWidth:SCREEN_WIDTH - 10 * 2].height + 10;
}

#pragma mark - DTAttributedTextContentViewDelegate

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame {
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    
    // get image with normal link text
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    // get image for highlighted link text
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    // use normal push action for opening URL
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)linkPushed:(id)sender {
    NSLog(@"linkPushed...");
}

@end
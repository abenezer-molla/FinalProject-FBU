//
//  LocationCell.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/15/21.
//

#import "LocationCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface LocationCell()
@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UILabel *locationAdress;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage;
@property (strong, nonatomic) NSDictionary *location;

@end

@implementation LocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithLocation:(NSDictionary *)location {
    self.locationTitle.text = location[@"name"];
    self.locationAdress.text = [location valueForKeyPath:@"location.address"];
    
    
    NSArray *categories = location[@"categories"];
    if (categories && categories.count > 0) {
        NSDictionary *category = categories[0];
        NSString *urlPrefix = [category valueForKeyPath:@"icon.prefix"];
        NSString *urlSuffix = [category valueForKeyPath:@"icon.suffix"];
        NSString *urlString = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
        
        NSURL *url = [NSURL URLWithString:urlString];
        [self.locationImage setImageWithURL:url];
    }
}

@end

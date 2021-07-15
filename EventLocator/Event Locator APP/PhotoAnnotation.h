//
//  PhotoAnnotation.h
//  Event Locator APP
//
//  Created by abenezermolla on 7/15/21.
//

#import <Foundation/Foundation.h>

#import "MapKit/MapKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) UIImage *photo;

@end

NS_ASSUME_NONNULL_END

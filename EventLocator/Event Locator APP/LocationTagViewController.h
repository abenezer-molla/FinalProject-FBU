//
//  LocationTagViewController.h
//  Event Locator APP
//
//  Created by abenezermolla on 7/15/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class LocationsViewController; // added this line to avoid the "Expected a type.

@protocol LocationsViewControllerDelegate

- (void)locationsViewController:(LocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;

@end

@interface LocationTagViewController : UIViewController


@property (weak, nonatomic) id<LocationsViewControllerDelegate> delegate;




@end

NS_ASSUME_NONNULL_END

//
//  PhotoMapViewController.h
//  Event Locator APP
//
//  Created by abenezermolla on 7/15/21.
//

#import <UIKit/UIKit.h>

#import "MapKit/MapKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

NS_ASSUME_NONNULL_END

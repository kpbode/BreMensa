#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class KPBMensa;

@interface KPBMensaLocationMarker : NSObject <MKAnnotation>

- (id)initWithMensa:(KPBMensa *)mensa;

@end

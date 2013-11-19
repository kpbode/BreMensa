#import <XCTest/XCTest.h>
#import "KPBMealplan.h"

@interface BreMensaTests : XCTestCase

@end

@implementation BreMensaTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIfMensaPlanIsBeingIndicatedAsInvalid
{
    
    NSString *jsonFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"invalid_mealplan" ofType:@"json"];
    XCTAssertNotNil(jsonFilePath, @"json file should not be nil");
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonFilePath];
    XCTAssertNotNil(jsonData, @"json data should not be nil");
    NSDictionary *mealplanDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
    XCTAssertNotNil(mealplanDictionary, @"dictionary should not be nil");
    
    KPBMealplan *mealplan = [KPBMealplan mealplanFromDictionary:mealplanDictionary];
    XCTAssertNotNil(mealplan, @"mealplan should not be nil");
    XCTAssertTrue([mealplan.menus count] == 4, @"there should be four menus, but there are %i", [mealplan.menus count]);
    XCTAssertFalse([mealplan isValid], @"mealplan should be invalid");
}

@end

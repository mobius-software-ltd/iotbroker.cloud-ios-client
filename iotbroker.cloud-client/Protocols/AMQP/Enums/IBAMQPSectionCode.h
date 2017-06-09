//
//  IBAMQPSectionCode.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(Byte, IBAMQPSectionCodes)
{
    IBAMQPHeaderSectionCode                 = 0x70,
    IBAMQPDeliveryAnnotationsSectionCode    = 0x71,
    IBAMQPMessageAnnotationsSectionCode     = 0x72,
    IBAMQPPropertiesSectionCode             = 0x73,
    IBAMQPApplicationPropertiesSectionCode  = 0x74,
    IBAMQPDataSectionCode                   = 0x75,
    IBAMQPSequenceSectionCode               = 0x76,
    IBAMQPValueSectionCode                  = 0x77,
    IBAMQPFooterSectionCode                 = 0x78,
};

@interface IBAMQPSectionCode : NSObject <NSCopying>

@property (assign, nonatomic) IBAMQPSectionCodes value;

- (instancetype) initWithSectionCode : (IBAMQPSectionCodes) type;
+ (instancetype) enumWithSectionCode : (IBAMQPSectionCodes) type;

- (NSString *) nameByValue;
- (IBAMQPSectionCodes) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end

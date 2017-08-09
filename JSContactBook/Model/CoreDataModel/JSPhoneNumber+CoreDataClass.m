//
//  JSPhoneNumber+CoreDataClass.m
//  
//
//  Created by Jayesh on 09/08/17.
//
//

#import "JSPhoneNumber+CoreDataClass.h"
#import "JSContact+CoreDataClass.h"

@implementation JSPhoneNumber

- (void)updateFromPhoneNumber:(CNLabeledValue<CNPhoneNumber *> * _Nonnull) phoneNumber
{
    self.phoneNumberIdentifier = phoneNumber.identifier;
    
    CNPhoneNumber *number = phoneNumber.value;
    self.phoneNumber = number.stringValue;
    self.label = [CNLabeledValue localizedStringForLabel:phoneNumber.label];
}

@end

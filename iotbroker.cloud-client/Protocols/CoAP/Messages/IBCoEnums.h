/**
 * Mobius Software LTD
 * Copyright 2015-2017, Mobius Software LTD
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

#ifndef IBCoEnums_h
#define IBCoEnums_h

typedef NS_ENUM (NSInteger, IBCoAPCodes)
{
    IBGETMethod                             = 1,
    IBPOSTMethod                            = 2,
    IBPUTMethod                             = 3,
    IBDELETEMethod                          = 4,
    IBEmptyResponseCode                     = 0,
    IBCreatedResponseCode                   = 65,
    IBDeletedResponseCode                   = 66,
    IBValidResponseCode                     = 67,
    IBChangedResponseCode                   = 68,
    IBContentResponseCode                   = 69,
    IBBadRequestResponseCode                = 128,
    IBUnauthorizedResponseCode              = 129,
    IBBadOptionResponseCode                 = 130,
    IBForbiddenResponseCode                 = 131,
    IBNotFoundResponseCode                  = 132,
    IBMethodNotAllowedResponseCode          = 133,
    IBNotAcceptableResponseCode             = 134,
    IBPreconditionFailedResponseCode        = 140,
    IBRequestEntityTooLargeResponseCode     = 141,
    IBUnsupportedContentFormatResponseCode  = 143,
    IBInternalServerErrorResponseCode       = 160,
    IBNotImplementedResponseCode            = 161,
    IBBadGatewayResponseCode                = 162,
    IBServiceUnavailableResponseCode        = 163,
    IBGatewayTimeoutResponseCode            = 164,
    IBProxyingNotSupportedResponseCode      = 165
};

typedef NS_ENUM (NSInteger, IBCoAPTypes)
{
    IBConfirmableType       = 0,
    IBNonConfirmableType    = 1,
    IBAcknowledgmentType    = 2,
    IBResetType             = 3,
};

typedef NS_ENUM (NSInteger, IBCoAPOptionDefinitions)
{
    IBIfMatchOption         = 1,
    IBUriHostOption         = 3,
    IBETagOption            = 4,
    IBIfNoneMatchOption     = 5,
    IBObserveOption         = 6,
    IBUriPortOption         = 7,
    IBLocationPathOption    = 8,
    IBUriPathOption         = 11,
    IBContentFormatOption   = 12,
    IBMaxAgeOption          = 14,
    IBUriQueryOption        = 15,
    IBAcceptOption          = 17,
    IBLocationQueryOption   = 20,
    IBBlock2Option          = 23,
    IBBlock1Option          = 27,
    IBSize2Option           = 28,
    IBProxyUriOption        = 35,
    IBProxySchemeOption     = 39,
    IBSize1Option           = 60,
    IBNodeId                = 2050,
};

typedef NS_ENUM (NSInteger, IBCoAPContentFormats)
{
    IBPlainContentFormat        = 0,
    IBLinkContentFormat         = 40,
    IBXMLContentFormat          = 41,
    IBOctetStreamContentFormat  = 42,
    IBEXIContentFormat          = 47,
    IBJSONContentFormat         = 50,
};

#endif /* IBCoEnums_h */

//
//  SCMessage.swift
//  SwiftCoAP
//
//  Created by Wojtek Kordylewski on 22.04.15.
//  Copyright (c) 2015 Wojtek Kordylewski. All rights reserved.
//

import UIKit


//MARK:
//MARK: SC Type Enumeration: Represents the CoAP types

public enum SCType: Int {
    case Confirmable, NonConfirmable, Acknowledgement, Reset

    public func shortString() -> String {
        switch self {
        case .Confirmable:
            return "CON"
        case .NonConfirmable:
            return "NON"
        case .Acknowledgement:
            return "ACK"
        case .Reset:
            return "RST"
        }
    }

    public static func fromShortString(string: String) -> SCType? {
        switch string.uppercaseString {
        case "CON":
            return .Confirmable
        case "NON":
            return .NonConfirmable
        case "ACK":
            return .Acknowledgement
        case "RST":
            return .Reset
        default:
            return nil
        }
    }
}


//MARK:
//MARK: SC Option Enumeration: Represents the CoAP options

public enum SCOption: Int {
    case IfMatch = 1
    case UriHost = 3
    case Etag = 4
    case IfNoneMatch = 5
    case Observe = 6
    case UriPort = 7
    case LocationPath = 8
    case UriPath = 11
    case ContentFormat = 12
    case MaxAge = 14
    case UriQuery = 15
    case Accept = 17
    case LocationQuery = 20
    case Block2 = 23
    case Block1 = 27
    case Size2 = 28
    case ProxyUri = 35
    case ProxyScheme = 39
    case Size1 = 60

    public static let allValues = [IfMatch, UriHost, Etag, IfNoneMatch, Observe, UriPort, LocationPath, UriPath, ContentFormat, MaxAge, UriQuery, Accept, LocationQuery, Block2, Block1, Size2, ProxyUri, ProxyScheme, Size1]

    public enum Format: Int {
        case Empty, Opaque, UInt, String
    }

    public func toString() -> String {
        switch self {
        case .IfMatch:
            return "If_Match"
        case .UriHost:
            return "URI_Host"
        case .Etag:
            return "ETAG"
        case .IfNoneMatch:
            return "If_None_Match"
        case .Observe:
            return "Observe"
        case .UriPort:
            return "URI_Port"
        case .LocationPath:
            return "Location_Path"
        case .UriPath:
            return "URI_Path"
        case .ContentFormat:
            return "Content_Format"
        case .MaxAge:
            return "Max_Age"
        case .UriQuery:
            return "URI_Query"
        case .Accept:
            return "Accept"
        case .LocationQuery:
            return "Location_Query"
        case .Block2:
            return "Block2"
        case .Block1:
            return "Block1"
        case .Size2:
            return "Size2"
        case .ProxyUri:
            return "Proxy_URI"
        case .ProxyScheme:
            return "Proxy_Scheme"
        case .Size1:
            return "Size1"
        }
    }

    public static func isNumberCritical(optionNo: Int) -> Bool {
        return optionNo % 2 == 1
    }

    public func isCritical() -> Bool {
        return SCOption.isNumberCritical(self.rawValue)
    }

    public static func isNumberUnsafe(optionNo: Int) -> Bool {
        return optionNo & 0b10 == 0b10
    }

    public func isUnsafe() -> Bool {
        return SCOption.isNumberUnsafe(self.rawValue)
    }

    public static func isNumberNoCacheKey(optionNo: Int) -> Bool {
        return optionNo & 0b11110 == 0b11100
    }

    public func isNoCacheKey() -> Bool {
        return SCOption.isNumberNoCacheKey(self.rawValue)
    }

    public static func isNumberRepeatable(optionNo: Int) -> Bool {
        switch optionNo {
        case SCOption.IfMatch.rawValue, SCOption.Etag.rawValue, SCOption.LocationPath.rawValue, SCOption.UriPath.rawValue, SCOption.UriQuery.rawValue, SCOption.LocationQuery.rawValue:
            return true
        default:
            return false
        }
    }

    public func isRepeatable() -> Bool {
        return SCOption.isNumberRepeatable(self.rawValue)
    }

    public func format() -> Format {
        switch self {
        case .IfNoneMatch:
            return .Empty
        case .IfMatch, .Etag:
            return .Opaque
        case .UriHost, .LocationPath, .UriPath, .UriQuery, .LocationQuery, .ProxyUri, .ProxyScheme:
            return .String
        default:
            return .UInt
        }
    }

    public func dataForValueString(valueString: String) -> NSData? {
        return SCOption.dataForOptionValueString(valueString, format: format())
    }

    public static func dataForOptionValueString(valueString: String, format: Format) -> NSData? {
        switch format {
        case .Empty:
            return nil
        case .Opaque:
            return NSData.fromOpaqueString(valueString)
        case .String:
            return valueString.dataUsingEncoding(NSUTF8StringEncoding)
        case .UInt:
            if let number = UInt(valueString) {
                var byteArray = number.toByteArray()
                return NSData(bytes: &byteArray, length: byteArray.count)
            }
            return nil
        }
    }
}


//MARK:
//MARK: SC Code Sample Enumeration: Provides the most common CoAP codes as raw values

public enum SCCodeSample: Int {
    case Empty = 0
    case Get = 1
    case Post = 2
    case Put = 3
    case Delete = 4
    case Created = 65
    case Deleted = 66
    case Valid = 67
    case Changed = 68
    case Content = 69
    case Continue = 95
    case BadRequest = 128
    case Unauthorized = 129
    case BadOption = 130
    case Forbidden = 131
    case NotFound = 132
    case MethodNotAllowed = 133
    case NotAcceptable = 134
    case RequestEntityIncomplete = 136
    case PreconditionFailed = 140
    case RequestEntityTooLarge = 141
    case UnsupportedContentFormat = 143
    case InternalServerError = 160
    case NotImplemented = 161
    case BadGateway = 162
    case ServiceUnavailable = 163
    case GatewayTimeout = 164
    case ProxyingNotSupported = 165

    public func codeValue() -> SCCodeValue! {
        return SCCodeValue.fromCodeSample(self)
    }

    public func toString() -> String {
        switch self {
        case .Empty:
            return "Empty"
        case .Get:
            return "Get"
        case .Post:
            return "Post"
        case .Put:
            return "Put"
        case .Delete:
            return "Delete"
        case .Created:
            return "Created"
        case .Deleted:
            return "Deleted"
        case .Valid:
            return "Valid"
        case .Changed:
            return "Changed"
        case .Content:
            return "Content"
        case .Continue:
            return "Continue"
        case .BadRequest:
            return "Bad Request"
        case .Unauthorized:
            return "Unauthorized"
        case .BadOption:
            return "Bad Option"
        case .Forbidden:
            return "Forbidden"
        case .NotFound:
            return "Not Found"
        case .MethodNotAllowed:
            return "Method Not Allowed"
        case .NotAcceptable:
            return "Not Acceptable"
        case .RequestEntityIncomplete:
            return "Request Entity Incomplete"
        case .PreconditionFailed:
            return "Precondition Failed"
        case .RequestEntityTooLarge:
            return "Request Entity Too Large"
        case .UnsupportedContentFormat:
            return "Unsupported Content Format"
        case .InternalServerError:
            return "Internal Server Error"
        case .NotImplemented:
            return "Not Implemented"
        case .BadGateway:
            return "Bad Gateway"
        case .ServiceUnavailable:
            return "Service Unavailable"
        case .GatewayTimeout:
            return "Gateway Timeout"
        case .ProxyingNotSupported:
            return "Proxying Not Supported"
        }
    }

    public static func stringFromCodeValue(codeValue: SCCodeValue) -> String? {
        return codeValue.toCodeSample()?.toString()
    }
}


//MARK:
//MARK: SC Content Format Enumeration

public enum SCContentFormat: UInt {
    case Plain = 0
    case LinkFormat = 40
    case XML = 41
    case OctetStream = 42
    case EXI = 47
    case JSON = 50
    case CBOR = 60

    public func needsStringUTF8Conversion() -> Bool {
        switch self {
        case .OctetStream, .EXI, .CBOR:
            return false
        default:
            return true
        }
    }

    public func toString() -> String {
        switch self {
        case .Plain:
            return "Plain"
        case .LinkFormat:
            return "Link Format"
        case .XML:
            return "XML"
        case .OctetStream:
            return "Octet Stream"
        case .EXI:
            return "EXI"
        case .JSON:
            return "JSON"
        case .CBOR:
            return "CBOR"
        }
    }
}


//MARK:
//MARK: SC Code Value struct: Represents the CoAP code. You can easily apply the CoAP code syntax c.dd (e.g. SCCodeValue(classValue: 0, detailValue: 01) equals 0.01)

public struct SCCodeValue: Equatable {
    public let classValue: UInt8
    public let detailValue: UInt8

    public init(rawValue: UInt8) {
        let firstBits: UInt8 = rawValue >> 5
        let lastBits: UInt8 = rawValue & 0b00011111
        self.classValue = firstBits
        self.detailValue = lastBits
    }

    //classValue must not be larger than 7; detailValue must not be larger than 31
    public init?(classValue: UInt8, detailValue: UInt8) {
        if classValue > 0b111 || detailValue > 0b11111 { return nil }

        self.classValue = classValue
        self.detailValue = detailValue
    }

    public func toRawValue() -> UInt8 {
        return classValue << 5 + detailValue
    }

    public func toCodeSample() -> SCCodeSample? {
        if let code = SCCodeSample(rawValue: Int(toRawValue())) {
            return code
        }
        return nil
    }

    public static func fromCodeSample(code: SCCodeSample) -> SCCodeValue {
        return SCCodeValue(rawValue: UInt8(code.rawValue))
    }

    public func toString() -> String {
        return String(format: "%i.%02d", classValue, detailValue)
    }

    public func requestString() -> String? {
        switch self {
        case SCCodeValue(classValue: 0, detailValue: 01)!:
            return "GET"
        case SCCodeValue(classValue: 0, detailValue: 02)!:
            return "POST"
        case SCCodeValue(classValue: 0, detailValue: 03)!:
            return "PUT"
        case SCCodeValue(classValue: 0, detailValue: 04)!:
            return "DELETE"
        default:
            return nil
        }
    }
}

public func ==(lhs: SCCodeValue, rhs: SCCodeValue) -> Bool {
    return lhs.classValue == rhs.classValue && lhs.detailValue == rhs.detailValue
}


//MARK:
//MARK: UInt Extension

public extension UInt {
    public func toByteArray() -> [UInt8] {
        let byteLength = UInt(ceil(log2(Double(self + 1)) / 8))
        var byteArray = [UInt8]()
        for var i: UInt = 0; i < byteLength; i++ {
            byteArray.append(UInt8(((self) >> ((byteLength - i - 1) * 8)) & 0xFF))
        }
        return byteArray
    }

    public static func fromData(data: NSData) -> UInt {
        var valueBytes = [UInt8](count: data.length, repeatedValue: 0)
        data.getBytes(&valueBytes, length: data.length)

        var actualValue: UInt = 0
        for var i = 0; i < valueBytes.count; i++ {
            actualValue += UInt(valueBytes[i]) << ((UInt(valueBytes.count) - UInt(i + 1)) * 8)
        }
        return actualValue
    }
}

//MARK:
//MARK: String Extension

public extension String {
    public static func toHexFromData(data: NSData) -> String {
        var string = data.description.stringByReplacingOccurrencesOfString(" ", withString: "")
        return "0x" + string.substringWithRange(Range<String.Index>(start: string.startIndex.advancedBy(1), end: string.endIndex.advancedBy(-1)))
    }
}

//MARK:
//MARK: NSData Extension

public extension NSData {
    public static func fromOpaqueString(string: String) -> NSData? {
        let comps = string.componentsSeparatedByString("x")
        if let lastString = comps.last, number = UInt(lastString, radix:16) where comps.count <= 2 {
            var byteArray = number.toByteArray()
            return NSData(bytes: &byteArray, length: byteArray.count)
        }
        return nil
    }
}

//MARK:
//MARK: Resource Implementation, used for SCServer

public class SCResourceModel: NSObject {
    public let name: String // Name of the resource
    public let allowedRoutes: UInt // Bitmask of allowed routes (see SCAllowedRoutes enum)
    public var maxAgeValue: UInt! // If not nil, every response will contain the provided MaxAge value
    private(set) var etag: NSData! // If not nil, every response to a GET request will contain the provided eTag. The etag is generated automatically whenever you update the dataRepresentation of the resource
    public var message: SCMessage?
    public var dataRepresentation: NSData! {
        didSet {
            if var hashInt = dataRepresentation?.hashValue {
                etag = NSData(bytes: &hashInt, length: sizeof(Int))
            }
        }
    }// The current data representation of the resource. Needs to stay up to date
    public var observable = false // If true, a response will contain the Observe option, and endpoints will be able to register as observers in SCServer. Call updateRegisteredObserversForResource(self), anytime your dataRepresentation changes.

    //Desigated initializer
    public init(name: String, allowedRoutes: UInt) {
        self.name = name
        self.allowedRoutes = allowedRoutes
    }


    //The Methods for Data reception for allowed routes. SCServer will call the appropriate message upon the reception of a reqeuest. Override the respective methods, which match your allowedRoutes.
    //SCServer passes a queryDictionary containing the URI query content (e.g ["user_id": "23"]) and all options contained in the respective request. The POST and PUT methods provide the message's payload as well.
    //Refer to the example resources in the SwiftCoAPServerExample project for implementation examples.


    //This method lets you decide whether the current GET request shall be processed asynchronously, i.e. if true will be returned, an empty ACK will be sent, and you can provide the actual response by calling the servers "didCompleteAsynchronousRequestForOriginalMessage(...)". Note: "dataForGet" will not be called additionally if you return true.
    public func willHandleDataAsynchronouslyForGet(queryDictionary queryDictionary: [String : String], options: [Int : [NSData]], originalMessage: SCMessage) -> Bool { return false }

    //The following methods require data for the given routes GET, POST, PUT, DELETE and must be overriden if needed. If you return nil, the server will respond with a "Method not allowed" error code (Make sure that you have set the allowed routes in the "allowedRoutes" bitmask property).
    //You have to return a tuple with a statuscode, optional payload, optional content format for your provided payload and (in case of POST and PUT) an optional locationURI.
    public func dataForGet(queryDictionary queryDictionary: [String : String], options: [Int : [NSData]]) -> (statusCode: SCCodeValue, payloadData: NSData?, contentFormat: SCContentFormat!)? { return nil }
    public func dataForPost(queryDictionary queryDictionary: [String : String], options: [Int : [NSData]], requestData: NSData?) -> (statusCode: SCCodeValue, payloadData: NSData?, contentFormat: SCContentFormat!, locationUri: String!)? { return nil }
    public func dataForPut(queryDictionary queryDictionary: [String : String], options: [Int : [NSData]], requestData: NSData?) -> (statusCode: SCCodeValue, payloadData: NSData?, contentFormat: SCContentFormat!, locationUri: String!)? { return nil }
    public func dataForDelete(queryDictionary queryDictionary: [String : String], options: [Int : [NSData]]) -> (statusCode: SCCodeValue, payloadData: NSData?, contentFormat: SCContentFormat!)? { return nil }
}

//MARK:
//MARK: SC Message IMPLEMENTATION

public class SCMessage: NSObject {

    //MARK: Constants and Properties

    //CONSTANTS
    public static let kCoapVersion = 0b01
    public static let kProxyCoAPTypeKey = "COAP_TYPE"

    public static let kCoapErrorDomain = "SwiftCoapErrorDomain"
    public static let kAckTimeout = 2.0
    public static let kAckRandomFactor = 1.5
    public static let kMaxRetransmit = 4
    public static let kMaxTransmitWait = 93.0

    public let kDefaultMaxAgeValue: UInt = 60
    public let kOptionOneByteExtraValue: UInt8 = 13
    public let kOptionTwoBytesExtraValue: UInt8 = 14

    //INTERNAL PROPERTIES (allowed to modify)

    public var code: SCCodeValue = SCCodeValue(classValue: 0, detailValue: 0)! //Code value is Empty by default
    public var type: SCType = .Confirmable //Type is CON by default
    public var payload: NSData? //Add a payload (optional)
    public var blockBody: NSData? //Helper for Block1 tranmission. Used by SCClient, modification has no effect

    public lazy var options = [Int: [NSData]]() //CoAP-Options. It is recommend to use the addOption(..) method to add a new option.


    //The following properties are modified by SCClient/SCServer. Modification has no effect and is therefore not recommended
    public var hostName: String?
    public var port: UInt16?
    public var addressData: NSData?
    public var resourceForConfirmableResponse: SCResourceModel?
    public var messageId: UInt16!
    public var token: UInt64 = 0

    public var timeStamp: NSDate?


    //MARK: Internal Methods (allowed to use)

    public convenience init(code: SCCodeValue, type: SCType, payload: NSData?) {
        self.init()
        self.code = code
        self.type = type
        self.payload = payload
    }

    public func equalForCachingWithMessage(message: SCMessage) -> Bool {
        if code == message.code && hostName == message.hostName && port == message.port {
            let firstSet = Set(options.keys)
            let secondSet = Set(message.options.keys)

            let exOr = firstSet.exclusiveOr(secondSet)

            for optNo in exOr {
                if !(SCOption.isNumberNoCacheKey(optNo)) { return false }
            }

            let interSect = firstSet.intersect(secondSet)

            for optNo in interSect {
                if !(SCOption.isNumberNoCacheKey(optNo)) && !(SCMessage.compareOptionValueArrays(options[optNo]!, second: message.options[optNo]!)) { return false }
            }
            return true
        }
        return false
    }

    public static func compareOptionValueArrays(first: [NSData], second: [NSData]) -> Bool {
        if first.count != second.count { return false }

        for var i = 0; i < first.count; i++ {
            if !first[i].isEqualToData(second[i]) { return false }
        }

        return true
    }

    public static func copyFromMessage(message: SCMessage) -> SCMessage {
        let copiedMessage = SCMessage(code: message.code, type: message.type, payload: message.payload)
        copiedMessage.options = message.options
        copiedMessage.hostName = message.hostName
        copiedMessage.port = message.port
        copiedMessage.messageId = message.messageId
        copiedMessage.token = message.token
        copiedMessage.timeStamp = message.timeStamp
        return copiedMessage
    }

    public func isFresh() -> Bool {
        func validateMaxAge(value: UInt) -> Bool {
            if timeStamp != nil {
                let expirationDate = timeStamp!.dateByAddingTimeInterval(Double(value))
                return NSDate().compare(expirationDate) != .OrderedDescending
            }
            return false
        }

        if let maxAgeValues = options[SCOption.MaxAge.rawValue], firstData = maxAgeValues.first {
            return validateMaxAge(UInt.fromData(firstData))
        }

        return validateMaxAge(kDefaultMaxAgeValue)
    }

    public func addOption(option: Int, data: NSData) {
        if var currentOptionValue = options[option] {
            currentOptionValue.append(data)
            options[option] = currentOptionValue
        }
        else {
            options[option] = [data]
        }
    }

    public func toData() -> NSData? {
        var resultData: NSMutableData

        let tokenLength = Int(ceil(log2(Double(token + 1)) / 8))
        if tokenLength > 8 {
            return nil
        }
        let codeRawValue = code.toRawValue()
        let firstByte: UInt8 = UInt8((SCMessage.kCoapVersion << 6) | (type.rawValue << 4) | tokenLength)
        let actualMessageId: UInt16 = messageId ?? 0
        var byteArray: [UInt8] = [firstByte, codeRawValue, UInt8(actualMessageId >> 8), UInt8(actualMessageId & 0xFF)]
        resultData = NSMutableData(bytes: &byteArray, length: byteArray.count)

        if tokenLength > 0 {
            var tokenByteArray = [UInt8]()
            for var i = 0; i < tokenLength; i++ {
                tokenByteArray.append(UInt8(((token) >> UInt64((tokenLength - i - 1) * 8)) & 0xFF))
            }
            resultData.appendBytes(&tokenByteArray, length: tokenLength)
        }

        let sortedOptions = options.sort {
            $0.0 < $1.0
        }

        var previousDelta = 0
        for (key, valueArray) in sortedOptions {
            for value in valueArray {
                let optionDelta = key - previousDelta
                previousDelta += optionDelta

                var optionFirstByte: UInt8
                var extendedDelta: NSData?
                var extendedLength: NSData?

                if optionDelta >= Int(kOptionTwoBytesExtraValue) + 0xFF {
                    optionFirstByte = kOptionTwoBytesExtraValue << 4
                    let extendedDeltaValue: UInt16 = UInt16(optionDelta) - (UInt16(kOptionTwoBytesExtraValue) + 0xFF)
                    var extendedByteArray: [UInt8] = [UInt8(extendedDeltaValue >> 8), UInt8(extendedDeltaValue & 0xFF)]

                    extendedDelta = NSData(bytes: &extendedByteArray, length: extendedByteArray.count)
                }
                else if optionDelta >= Int(kOptionOneByteExtraValue) {
                    optionFirstByte = kOptionOneByteExtraValue << 4
                    var extendedDeltaValue: UInt8 = UInt8(optionDelta) - kOptionOneByteExtraValue
                    extendedDelta = NSData(bytes: &extendedDeltaValue, length: 1)
                }
                else {
                    optionFirstByte = UInt8(optionDelta) << 4
                }

                if value.length >= Int(kOptionTwoBytesExtraValue) + 0xFF {
                    optionFirstByte += kOptionTwoBytesExtraValue
                    let extendedLengthValue: UInt16 = UInt16(value.length) - (UInt16(kOptionTwoBytesExtraValue) + 0xFF)
                    var extendedByteArray: [UInt8] = [UInt8(extendedLengthValue >> 8), UInt8(extendedLengthValue & 0xFF)]

                    extendedLength = NSData(bytes: &extendedByteArray, length: extendedByteArray.count)
                }
                else if value.length >= Int(kOptionOneByteExtraValue) {
                    optionFirstByte += kOptionOneByteExtraValue
                    var extendedLengthValue: UInt8 = UInt8(value.length) - kOptionOneByteExtraValue
                    extendedLength = NSData(bytes: &extendedLengthValue, length: 1)
                }
                else {
                    optionFirstByte += UInt8(value.length)
                }

                resultData.appendBytes(&optionFirstByte, length: 1)
                if extendedDelta != nil {
                    resultData.appendData(extendedDelta!)
                }
                if extendedLength != nil {
                    resultData.appendData(extendedLength!)
                }

                resultData.appendData(value)
            }
        }

        if payload != nil {
            var payloadMarker: UInt8 = 0xFF
            resultData.appendBytes(&payloadMarker, length: 1)
            resultData.appendData(payload!)
        }
        return resultData
    }

    public static func fromData(data: NSData) -> SCMessage? {
        if data.length < 4 { return nil }
        //Unparse Header
        var parserIndex = 4
        var headerBytes = [UInt8](count: parserIndex, repeatedValue: 0)
        data.getBytes(&headerBytes, length: parserIndex)

        var firstByte = headerBytes[0]
        let tokenLenght = Int(firstByte) & 0xF
        firstByte >>= 4
        let type = SCType(rawValue: Int(firstByte) & 0b11)
        firstByte >>= 2
        if tokenLenght > 8 || type == nil || firstByte != UInt8(kCoapVersion)  { return nil }

        //Assign header values to CoAP Message
        let message = SCMessage()
        message.type = type!
        message.code = SCCodeValue(rawValue: headerBytes[1])
        message.messageId = (UInt16(headerBytes[2]) << 8) + UInt16(headerBytes[3])

        if tokenLenght > 0 {
            var tokenByteArray = [UInt8](count: tokenLenght, repeatedValue: 0)
            data.getBytes(&tokenByteArray, range: NSMakeRange(4, tokenLenght))
            for var i = 0; i < tokenByteArray.count; i++ {
                message.token += UInt64(tokenByteArray[i]) << ((UInt64(tokenByteArray.count) - UInt64(i + 1)) * 8)
            }
        }
        parserIndex += tokenLenght

        var currentOptDelta = 0
        while parserIndex < data.length {
            var nextByte: UInt8 = 0
            data.getBytes(&nextByte, range: NSMakeRange(parserIndex, 1))
            parserIndex++

            if nextByte == 0xFF {
                message.payload = data.subdataWithRange(NSMakeRange(parserIndex, data.length - parserIndex))
                break
            }
            else {
                let optLength = nextByte & 0xF
                nextByte >>= 4
                if nextByte == 0xF || optLength == 0xF { return nil }

                var finalDelta = 0
                switch nextByte {
                case 13:
                    data.getBytes(&finalDelta, range: NSMakeRange(parserIndex, 1))
                    finalDelta += 13
                    parserIndex++
                case 14:
                    var twoByteArray = [UInt8](count: 2, repeatedValue: 0)
                    data.getBytes(&twoByteArray, range: NSMakeRange(parserIndex, 2))
                    finalDelta = (Int(twoByteArray[0]) << 8) + Int(twoByteArray[1])
                    finalDelta += (14 + 0xFF)
                    parserIndex += 2
                default:
                    finalDelta = Int(nextByte)
                }
                finalDelta += currentOptDelta
                currentOptDelta = finalDelta
                var finalLenght = 0
                switch optLength {
                case 13:
                    data.getBytes(&finalLenght, range: NSMakeRange(parserIndex, 1))
                    finalLenght += 13
                    parserIndex++
                case 14:
                    var twoByteArray = [UInt8](count: 2, repeatedValue: 0)
                    data.getBytes(&twoByteArray, range: NSMakeRange(parserIndex, 2))
                    finalLenght = (Int(twoByteArray[0]) << 8) + Int(twoByteArray[1])
                    finalLenght += (14 + 0xFF)
                    parserIndex += 2
                default:
                    finalLenght = Int(optLength)
                }

                var optValue = NSData()
                if finalLenght > 0 {
                    optValue = data.subdataWithRange(NSMakeRange(parserIndex, finalLenght))
                    parserIndex += finalLenght
                }
                message.addOption(finalDelta, data: optValue)
            }
        }

        return message
    }

    public func toHttpUrlRequestWithUrl() -> NSMutableURLRequest {
        let urlRequest = NSMutableURLRequest()
        if code != SCCodeSample.Get.codeValue() {
            urlRequest.HTTPMethod = code.requestString()!
        }

        for (key, valueArray) in options {
            for value in valueArray {
                var fieldString: String
                if let optEnum = SCOption(rawValue: key) {
                    switch optEnum.format() {
                    case .String:
                        fieldString = NSString(data: value, encoding: NSUTF8StringEncoding) as? String ?? ""
                    case .Empty:
                        fieldString = ""
                    default:
                        fieldString = String(UInt.fromData(value))
                    }
                }
                else {
                    fieldString = ""
                }

                if let optionName = SCOption(rawValue: key)?.toString().uppercaseString {
                    urlRequest.addValue(String(fieldString), forHTTPHeaderField: optionName)
                }
            }
        }
        urlRequest.HTTPBody = payload

        return urlRequest
    }

    public static func fromHttpUrlResponse(urlResponse: NSHTTPURLResponse, data: NSData!) -> SCMessage {
        let message = SCMessage()
        message.payload = data
        message.code = SCCodeValue(rawValue: UInt8(urlResponse.statusCode & 0xff))
        if let typeString = urlResponse.allHeaderFields[SCMessage.kProxyCoAPTypeKey] as? String, type = SCType.fromShortString(typeString) {
            message.type = type
        }
        for opt in SCOption.allValues {
            if let optValue = urlResponse.allHeaderFields["HTTP_\(opt.toString().uppercaseString)"] as? String {
                var optValueData: NSData
                switch opt.format() {
                case .Empty:
                    optValueData = NSData()
                case .String:
                    optValueData = optValue.dataUsingEncoding(NSUTF8StringEncoding)!
                default:
                    if let intVal = Int(optValue) {
                        var byteArray = UInt(intVal).toByteArray()
                        optValueData = NSData(bytes: &byteArray, length: byteArray.count)
                    }
                    else {
                        optValueData = NSData()
                    }
                }
                message.options[opt.rawValue] = [optValueData]
            }
        }
        return message
    }

    public func completeUriPath() -> String {
        var finalPathString: String = ""
        if let pathDataArray = options[SCOption.UriPath.rawValue] {
            for var i = 0; i < pathDataArray.count; i++ {
                if let pathString = NSString(data: pathDataArray[i], encoding: NSUTF8StringEncoding) {
                    if  i > 0 { finalPathString += "/"}
                    finalPathString += String(pathString)
                }
            }
        }
        return finalPathString
    }

    public func uriQueryDictionary() -> [String : String] {
        var resultDict = [String : String]()
        if let queryDataArray = options[SCOption.UriQuery.rawValue] {
            for queryData in queryDataArray {
                if let queryString = NSString(data: queryData, encoding: NSUTF8StringEncoding) {
                    let splitArray = queryString.componentsSeparatedByString("=")
                    if splitArray.count == 2 {
                        resultDict[splitArray.first!] = splitArray.last!
                    }
                }
            }
        }
        return resultDict
    }

    public static func getPathAndQueryDataArrayFromUriString(uriString: String) -> (pathDataArray: [NSData], queryDataArray: [NSData])? {

        func dataArrayFromString(string: String!, withSeparator separator: String) -> [NSData] {
            var resultDataArray = [NSData]()
            if string != nil {
                let stringArray = string.componentsSeparatedByString(separator)
                for subString in stringArray {
                    if let data = subString.dataUsingEncoding(NSUTF8StringEncoding) {
                        resultDataArray.append(data)
                    }
                }
            }
            return resultDataArray
        }

        let splitArray = uriString.componentsSeparatedByString("?")

        if splitArray.count <= 2 {
            let resultPathDataArray = dataArrayFromString(splitArray.first, withSeparator: "/")
            let resultQueryDataArray = splitArray.count == 2 ? dataArrayFromString(splitArray.last, withSeparator: "&") : []

            return (resultPathDataArray, resultQueryDataArray)
        }
        return nil
    }

    public func inferredContentFormat() -> SCContentFormat {
        guard let contentFormatArray = options[SCOption.ContentFormat.rawValue], contentFormatData = contentFormatArray.first, contentFormat = SCContentFormat(rawValue: UInt.fromData(contentFormatData)) else { return .Plain }
        return contentFormat
    }

    public func payloadRepresentationString() -> String {
        guard let payloadData = self.payload else { return "" }

        return SCMessage.payloadRepresentationStringForData(payloadData, contentFormat: inferredContentFormat())
    }

    public static func payloadRepresentationStringForData(data: NSData, contentFormat: SCContentFormat) -> String {
        if contentFormat.needsStringUTF8Conversion() {
            return (NSString(data: data, encoding: NSUTF8StringEncoding) as? String) ?? "Format Error"
        }
        return String.toHexFromData(data)
    }
}

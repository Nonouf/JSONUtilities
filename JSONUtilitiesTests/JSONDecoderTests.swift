//
//  JSONDecoderTests.swift
//  JSONUtilities
//
//  Created by Luciano Marisi on 21/11/2015.
//  Copyright © 2015 TechBrewers LTD. All rights reserved.
//

import XCTest
@testable import JSONUtilities

class JSONDecoderTests: XCTestCase {
  
  lazy var testBundle : NSBundle = {
    return NSBundle(forClass: self.dynamicType)
  }()
  
  func testFailedMainBundle() {
    do {
      let _ = try JSONDictionary.fromFile(JSONFilename.correct)
      XCTAssertTrue(false)
    } catch {
      XCTAssertTrue(true)
    }
  }
  
  func testCorrectDecodingForMandatoryJSON() {
    do {
      let jsonDictionary = try JSONDictionary.fromFile(JSONFilename.correct, bundle: testBundle)
      let mockJSONParent = try MockMandatoryParent(jsonDictionary: jsonDictionary)
      XCTAssertEqual(mockJSONParent.string, "stringValue")
      XCTAssertEqual(mockJSONParent.integer, 1)
      XCTAssertEqual(mockJSONParent.double, 1.2)
      XCTAssertEqual(mockJSONParent.bool, true)
      XCTAssertEqual(mockJSONParent.stringArray, ["1","2"])
      XCTAssertEqual(mockJSONParent.integerArray, [1,2])
      let nestedStruct = mockJSONParent.nestedObject
      XCTAssertEqual(nestedStruct.string, "stringValue")
      XCTAssertEqual(nestedStruct.integer, 1)
      XCTAssertEqual(nestedStruct.double, 1.2)
      XCTAssertEqual(nestedStruct.bool, true)
    } catch {
      XCTAssertTrue(false)
    }
  }
  
  func testIncorrectDecodingForMandatoryJSON() {
    do {
      let jsonDictionary = try JSONDictionary.fromFile(JSONFilename.empty, bundle: testBundle)
      let _ = try MockMandatoryParent(jsonDictionary: jsonDictionary)
      XCTAssertTrue(false)
    } catch let error as DecodingError {
      XCTAssertEqual(error.description, "ParseError: stringKey")
    } catch {
      XCTAssertTrue(false)
    }
  }
  
  func testIncorrectDecodingForMandatoryJSONNestedObject() {
    do {
      let jsonDictionary = try JSONDictionary.fromFile(JSONFilename.correctWithoutNested, bundle: testBundle)
      let _ = try MockMandatoryParent(jsonDictionary: jsonDictionary)
      XCTAssertTrue(false)
    } catch let error as DecodingError {
      XCTAssertEqual(error.description, "ParseError: nestedObjectKey")
    } catch {
      XCTAssertTrue(false)
    }
  }
  
  func testCorrectDecodingForOptionalJSON() {
    do {
      let jsonDictionary = try JSONDictionary.fromFile(JSONFilename.correct, bundle: testBundle)
      let mockJSONParent = OptionalMockJSONStructure(jsonDictionary: jsonDictionary)
      XCTAssertEqual(mockJSONParent.string, "stringValue")
      XCTAssertEqual(mockJSONParent.integer, 1)
      XCTAssertEqual(mockJSONParent.double, 1.2)
      XCTAssertEqual(mockJSONParent.bool, true)
      guard let nestedStruct = mockJSONParent.nestedObject else {
        XCTAssertTrue(false)
        return
      }
      XCTAssertEqual(nestedStruct.string, "stringValue")
      XCTAssertEqual(nestedStruct.integer, 1)
      XCTAssertEqual(nestedStruct.double, 1.2)
      XCTAssertEqual(nestedStruct.bool, true)
    } catch {
      XCTAssertTrue(false)
    }
  }
  
  func testCorrectDecodingForOptionalJSONwithoutNestedObject() {
    do {
      let jsonDictionary = try JSONDictionary.fromFile(JSONFilename.correctWithoutNested, bundle: testBundle)
      let mockJSONParent = OptionalMockJSONStructure(jsonDictionary: jsonDictionary)
      XCTAssertEqual(mockJSONParent.string, "stringValue")
      XCTAssertEqual(mockJSONParent.integer, 1)
      XCTAssertEqual(mockJSONParent.double, 1.2)
      XCTAssertEqual(mockJSONParent.bool, true)
      guard let _ = mockJSONParent.nestedObject else {
        XCTAssertTrue(true)
        return
      }
    } catch {
      XCTAssertTrue(false)
    }
  }
  
  func testCorrectDecodingForOptionalNilJSON() {
    do {
      let jsonDictionary = try JSONDictionary.fromFile(JSONFilename.empty, bundle: testBundle)
      let mockJSONStructure = OptionalMockJSONStructure(jsonDictionary: jsonDictionary)
      XCTAssertNil(mockJSONStructure.string)
      XCTAssertNil(mockJSONStructure.integer)
      XCTAssertNil(mockJSONStructure.double)
      XCTAssertNil(mockJSONStructure.bool)
    } catch {
      XCTAssertTrue(false)
    }
  }
  
  
}
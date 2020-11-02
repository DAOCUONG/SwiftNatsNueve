//
//  Extension.swift
//  SwiftNatsNueve
//
//  Created by Denis Kozhukhov on 11/03/2020.
//  Copyright © 2020 Denis Kozhukhov. All rights reserved.
//

extension Data {
	func toString() -> String? {
		NSString(data: self, encoding: String.Encoding.utf8.rawValue) as String?
	}
}

extension InputStream {
	func readStream() -> Data? {
		let max_buffer = 4096
		var dataQueue = [Data]()
		var length = max_buffer
		let buf = NSMutableData(capacity: max_buffer)
		let buffer = UnsafeMutablePointer<UInt8>(mutating: buf!.bytes.bindMemory(to: UInt8.self, capacity: buf!.length))
        
		// read stream per max_buffer
		while length > 0 {
			length = self.read(buffer, maxLength: max_buffer)
			guard length > 0 else { break }
			dataQueue.append(Data(bytes: UnsafePointer<UInt8>(buffer), count: length))
			if length < max_buffer { break }
		}

		guard !dataQueue.isEmpty else { return nil }

		let data = dataQueue.reduce(Data()) {
			var combined = NSData(data: $0) as Data
			combined.append($1)
			return combined
		}

		// print("readStream \(data.toString())")

		return data
	}

	func readStreamLoop() -> String? {
		while true {
			if self.hasBytesAvailable {
				return readStream()?.toString()
			}
			if streamError != nil { break }
		}

		return nil
	}
}

extension OutputStream {
	func writeStream(_ data: Data) {
		let bytes = (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count)
		_ = write(bytes, maxLength: data.count)

		// print("writeStream \(data.toString())")
	}

	func writeStreamLoop(_ data: Data) {
		while true {
			if hasSpaceAvailable {
				writeStream(data)
				break
			}
			if streamError != nil { break }
		}
	}
}

extension String
{
    var unicode: [UnicodeScalar] {
        unicodeScalars.filter { $0.isASCII }.map { $0 }
    }
    
	func flattenedMessage() -> String {
        components(separatedBy: CharacterSet.newlines).reduce("", { $0 + $1 })
	}

	func removePrefix(_ prefix: String) -> String {
        let indexOfPrefixEnd = self.index(self.startIndex, offsetBy: prefix.count)
        return String(suffix(from: indexOfPrefixEnd))
	}

	func convertToDictionary() -> [String: AnyObject]? {
		if let data = data(using: String.Encoding.utf8) {
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
			} catch let error as NSError {
				print(error)
			}
		}
		return nil
	}

	static func randomize(_ prefix: String = "", length: Int = 0) -> String {

		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		let lettersLength = UInt32(letters.count)

		let randomCharacters = (0..<length).map { i -> String in
			let offset = Int(arc4random_uniform(lettersLength))
			let c = letters[letters.index(letters.startIndex, offsetBy: offset)]
			return String(c)
		}

		return prefix + randomCharacters.joined(separator: "")
	}
}

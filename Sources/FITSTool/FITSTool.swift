/*
 
 Copyright (c) <2020>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */
import FITS
import ArgumentParser
import Foundation

struct FITSTool: ParsableCommand {
    
    struct Options : ParsableArguments {
        
        @Flag(name: .shortAndLong, help: "Show extra logging for debugging purposes")
        internal var verbose: Bool = false
        
        @Flag(name: .shortAndLong, help: "Recursive traversion through directories")
        internal var recursive: Bool = false
        
        @Argument(help: "The path to the FITS file(s)")
        internal var path: [String] = []
    }
    
    //let log = Logger(label: "tool.fits")
    
    static let configuration = CommandConfiguration(
        commandName: "fitstool",
        abstract: "A Swift command-line tool to read FITS files",
        version: "1.0",
        subcommands: [Search.self, Plot.self, Verify.self],
        defaultSubcommand: Search.self)

    static func process(url: URL, recursive: Bool, verbose: Bool, handle: (FitsFile) -> Void) {
        
        let keys: Set<URLResourceKey> = .init(arrayLiteral: .isDirectoryKey, .isReadableKey)
        let vals = try? url.resourceValues(forKeys: keys)
        
        guard vals?.isReadable ?? false else {
            print("Unable to read \(url.path)")
            return
        }
        
        if vals?.isDirectory ?? false && recursive {
            // directory URL
            if let urls = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: Array(keys), options: .skipsPackageDescendants){
                urls.forEach { url in
                    FITSTool.process(url: url, recursive: recursive, verbose: verbose, handle: handle)
                }
            }
            
        } else {
            // file URL
            
            guard ["fit","fits","FIT","FITS"].contains(url.pathExtension) else {
                if verbose { print("Skipping \(url.path)") }
                return
            }
            
            if verbose {
                print("\n-\(url.path.pad("-", count: 79))")
            }
            
            FitsFile.read(from: url, onError: { error in
                print(error)
                return
            }, onCompletion: { file in
                
                handle(file)
            })
        }
    }
    
}

extension String {
    
     func pad(_ char: Character, count: Int) -> String {
        
        guard count > self.count else {
            return self
        }
        
        let x = count - self.count
        return self+String(repeating: char, count: x)
    }
}

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
    
    //let log = Logger(label: "tool.fits")
    
    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to read FITS files",
        version: "1.0",
        subcommands: [])
    
    @Argument(help: "The path to the file")
    private var path: [String]
    
    @Option(help: "Examine a specific HDU")
    private var hdu: Int?
    
    @Flag(name: .shortAndLong, help: "Show extra logging for debugging purposes")
    private var verbose: Bool
    
    @Flag(name: .shortAndLong, help: "Recursive traversion through directories")
    private var recursive: Bool
    
    @Flag(name: .customShort("L"), help: "Print list of HDUs")
    private var list: Bool
    
    @Flag(name: .customShort("T"), help: "Print content of tables")
    private var plotTable: Bool
    
    @Flag(name: .customShort("V"), help: "Print validation results")
    private var validate: Bool
    
    init() { }
    
    func run() throws {
        
        for p in path {
            
            let url = URL(fileURLWithPath: p)
            
            guard FileManager.default.isReadableFile(atPath: p) else {
                print("Unable to read \(p)")
                continue
            }
            
            
            
            self.process(url: url)
        }
        
        print("Done.")
        return
        
        /*
        guard FileManager.default.isReadableFile(atPath: path) else {
            print("File not found")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        if verbose {
            print("Reading \(url.absoluteString) ...")
        }
        
        FitsFile.read(from: url, onError: { error in
            print(error)
            return
        }, onCompletion: { file in
            
            process(file: file)
            
            
        })
 */
    }
    
    func process(url: URL) {
        
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
                    process(url: url)
                }
            }
            
        } else {
            // file URL
            
            guard ["fit","fits","FIT","FITS"].contains(url.pathExtension) else {
                if verbose { print("Skipping \(url.path)") }
                return
            }
            
            print("\n\n-\(url.lastPathComponent.pad("-", count: 79))")
            if verbose {
                print("Reading \(url.absoluteString) ...")
            }
            
            FitsFile.read(from: url, onError: { error in
                print(error)
                return
            }, onCompletion: { file in
                
                process(file: file)
            })
        }
    }
    
    func process(file: FitsFile){
        
        if let hdu = hdu {
            // list only specified HDU
            if hdu == 0 {
                process(hdu: file.prime)
            } else {
                process(hdu: file.HDUs[hdu])
            }
        } else {
            // process all HDUs
            process(hdu: file.prime)
            file.HDUs.forEach { hdu in
                process(hdu: hdu)
            }
        }
    }
    
    func process(hdu: AnyHDU){
        
        if list {
            list(hdu: hdu)
        }
        if plotTable, let table = hdu as? TableHDU {
            var dat = Data()
            table.plot(data: &dat)
            print(String(data: dat, encoding: .ascii) ?? "N/A")
        }
        if plotTable, let table = hdu as? BintableHDU {
            var dat = Data()
            table.plot(data: &dat)
            print(String(data: dat, encoding: .ascii) ?? "N/A")
        }
        if validate {
            let validated = hdu.validate { message in
                print(message)
            }
            if !validated {
                print("Validation Failed!")
            } else {
                print("Validation Successful")
            }
        }
        
    }
    
    func list(hdu: AnyHDU){
        
        if verbose{
            print(hdu.debugDescription)
        } else {
            print(hdu.description)
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

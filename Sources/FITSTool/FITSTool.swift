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
    private var path: String
    
    @Option(help: "Examine a specific HDU")
    private var hdu: Int?
    
    @Flag(name: .shortAndLong, help: "Show extra logging for debugging purposes")
    private var verbose: Bool
    
    @Flag(name: .customShort("L"), help: "Show list of hdus")
    private var list: Bool
    
    @Flag(name: .customShort("V"), help: "Validate hdus")
    private var validate: Bool
    
    init() { }
    
    mutating func run() throws {
        
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
    }
    
    func process(file: FitsFile){
        
        if let hdu = hdu {
            // list only specified HDU
            if hdu == 0 {
                
            } else {
                
            }
        } else {
            // process all HDUs
            process(hdu: file.prime)
            file.HDUs.forEach { hdu in
                process(hdu: hdu)
            }
        }
        
        print("Done.")
    }
    
    func process(hdu: AnyHDU){
        
        if list {
            list(hdu: hdu)
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
        
        print("--- \(type(of: hdu)) -------------")
        if verbose{
            print(hdu.debugDescription)
        } else {
            print(hdu.description)
        }
        
    }
    
}

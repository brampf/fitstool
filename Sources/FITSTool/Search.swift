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

extension FITSTool {
    
    struct Search : ParsableCommand {
        
        static var configuration = CommandConfiguration(
            commandName: "search",
            abstract: "Search through all headers.")
        
        @Argument(help: "The string to search for")
        private var term: String = ""
  
        @OptionGroup var options : FITSTool.Options
        
        func run() throws {
            
            for p in options.path {
                
                let url = URL(fileURLWithPath: p)
                
                guard FileManager.default.isReadableFile(atPath: p) else {
                    print("Unable to read \(p)")
                    continue
                }
                
                FITSTool.process(url: url, recursive: options.recursive, verbose: options.verbose, handle: search(file:))
            }
            
            print("Done.")
            return
            
        }
        
        func search(file: FitsFile){
            
            search(hdu: file.prime)
            file.HDUs.forEach { hdu in
                search(hdu: hdu)
            }
            
        }
        
        func search(hdu: AnyHDU) {
            
            hdu.headerUnit.forEach { block in
                
                if block.description.lowercased().contains(term.lowercased()){
                    print("Match: \(block.description)")
                }

            }
        }
        
    }
    
}

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
 
    struct Verify : ParsableCommand {
     
        @OptionGroup var options : FITSTool.Options

        func run() throws {
            
            print(options.path)
            
            for p in options.path {
                
                let url = URL(fileURLWithPath: p)
                
                guard FileManager.default.isReadableFile(atPath: p) else {
                    print("Unable to read \(p)")
                    continue
                }
                
                FITSTool.process(url: url, recursive: options.recursive, verbose: true, handle: verify(file:))
            }
            
            print("Done.")
            return
            
        }
        
        func verify(file: FitsFile){
            
            verify(hdu: file.prime)
            file.HDUs.forEach { hdu in
                verify(hdu: hdu)
            }
        }
        
        func verify(hdu: AnyHDU){
            
            if hdu is PrimaryHDU {
                print("Primary HDU")
            } else {
                print(hdu.extname ?? type(of: hdu))
            }
            
            let result = hdu.validate { msg in
                print("  \(msg)")
            }
            if result {
                print("  Verification successful")
            } else {
                print("  Verification failed")
            }
            
        }
    }
}

//
//  Array_Extensions.swift
//  SIMD_Accelerate_Matrix_Math
//
//  Created by Eric Kampman on 1/15/23.
//

import simd
import Accelerate

// simd supports incompletely defined array values, but for now I'm only allowing completely defined
// (even if diagonal, symmetric, etc.)
extension Array {
	
	// returns 0 if not square
	func getSquareArrayColumnCount() -> UInt {
		guard isUIntSquare(UInt(self.count)) else { return 0 }
		return UInt(sqrt(Double(self.count)))
	}

	// Indices are column first, which makes my brain hurt
	func getValueOfColumnArray(row: UInt, column: UInt) -> Element? {
		let cols = getSquareArrayColumnCount()
		if (0 == cols) { return nil }		// not square
		
		let index = column * cols + row
		guard index < count else { return nil }
		
		return self[Int(index)]
	}

	/* no point in generic because looks like larger simd arrays are always Float ... ?*/
	/* array is column-based (e.g. 2nd entry is row 2 col 1) */
	func get2x2FromSquareArray(startRow: UInt, startColumn: UInt) -> simd_float2x2? {
		if (!isUIntSquare(UInt(count))) {
			return nil
		}
		
		guard let r2c2 = self.getValueOfColumnArray(row: startRow+1, column: startColumn+1) as? Float,
			  let r2c1 = self.getValueOfColumnArray(row: startRow+1, column: startColumn) as? Float,
			  let r1c2 = self.getValueOfColumnArray(row: startRow, column: startColumn+1) as? Float,
			  let r1c1 = self.getValueOfColumnArray(row: startRow, column: startColumn) as? Float
		else {
			return nil
		}

		let col1 = SIMD2<Float>(r1c1,r2c1)
		let col2 = SIMD2<Float>(r1c2,r2c2)

		return simd_float2x2(columns: (col1, col2))
	}
	
	func get3x3FromSquareArray(startRow: UInt, startColumn: UInt) -> simd_float3x3? {
		if (!isUIntSquare(UInt(count))) {
			return nil
		}

		guard let r3c3 = self.getValueOfColumnArray(row: startRow+2, column: startColumn+2) as? Float,
			  let r3c2 = self.getValueOfColumnArray(row: startRow+2, column: startColumn+1) as? Float,
			  let r3c1 = self.getValueOfColumnArray(row: startRow+2, column: startColumn) as? Float,
			  
			  let r2c3 = self.getValueOfColumnArray(row: startRow+1, column: startColumn+2) as? Float,
			  let r2c2 = self.getValueOfColumnArray(row: startRow+1, column: startColumn+1) as? Float,
			  let r2c1 = self.getValueOfColumnArray(row: startRow+1, column: startColumn) as? Float,
			  
			  let r1c1 = self.getValueOfColumnArray(row: startRow, column: startColumn+2) as? Float,
			  let r1c2 = self.getValueOfColumnArray(row: startRow, column: startColumn+1) as? Float,
			  let r1c3 = self.getValueOfColumnArray(row: startRow, column: startColumn) as? Float
		else {
			return nil
		}

		let col1 = SIMD3<Float>(r1c1,r2c1,r3c1)
		let col2 = SIMD3<Float>(r1c2,r2c2,r3c2)
		let col3 = SIMD3<Float>(r1c3,r2c3,r3c3)

		return simd_float3x3(columns: (col1, col2, col3))
	}

	func get4x4FromSquareArray(startRow: UInt, startColumn: UInt) -> simd_float4x4? {
		if (!isUIntSquare(UInt(count))) {
			return nil
		}

		guard let r4c4 = self.getValueOfColumnArray(row: startRow+3, column: startColumn+3) as? Float,
			  let r4c3 = self.getValueOfColumnArray(row: startRow+3, column: startColumn+2) as? Float,
			  let r4c2 = self.getValueOfColumnArray(row: startRow+3, column: startColumn+1) as? Float,
			  let r4c1 = self.getValueOfColumnArray(row: startRow+3, column: startColumn) as? Float,
			  
			  let r3c4 = self.getValueOfColumnArray(row: startRow+2, column: startColumn+3) as? Float,
			  let r3c3 = self.getValueOfColumnArray(row: startRow+2, column: startColumn+2) as? Float,
			  let r3c2 = self.getValueOfColumnArray(row: startRow+2, column: startColumn+1) as? Float,
			  let r3c1 = self.getValueOfColumnArray(row: startRow+2, column: startColumn) as? Float,
			  
			  let r2c4 = self.getValueOfColumnArray(row: startRow+1, column: startColumn+3) as? Float,
			  let r2c3 = self.getValueOfColumnArray(row: startRow+1, column: startColumn+2) as? Float,
			  let r2c2 = self.getValueOfColumnArray(row: startRow+1, column: startColumn+1) as? Float,
			  let r2c1 = self.getValueOfColumnArray(row: startRow+1, column: startColumn) as? Float,
			  
			  let r1c4 = self.getValueOfColumnArray(row: startRow, column: startColumn+3) as? Float,
			  let r1c3 = self.getValueOfColumnArray(row: startRow, column: startColumn+2) as? Float,
			  let r1c2 = self.getValueOfColumnArray(row: startRow, column: startColumn+1) as? Float,
			  let r1c1 = self.getValueOfColumnArray(row: startRow, column: startColumn) as? Float
		else {
			return nil
		}

		let col1 = SIMD4<Float>(r1c1,r2c1,r3c1,r4c1)
		let col2 = SIMD4<Float>(r1c2,r2c2,r3c2,r4c2)
		let col3 = SIMD4<Float>(r1c3,r2c3,r3c3,r4c3)
		let col4 = SIMD4<Float>(r1c4,r2c4,r3c4,r4c4)

		return simd_float4x4(columns: (col1, col2, col3, col4))
	}

	func cofactorOfColumnArrayForRow(_ row: UInt, column: UInt) -> [Float]? {
		let cols = getSquareArrayColumnCount()
		if 0 == cols { return nil }
		var ret = [Float]()
		for c in 0..<cols {
			for r in 0..<cols {  // square matrix
				if r == row { continue }
				// FIXME -- this could be optimized substantially by not calling getValueOfColumnArray
				guard let val = getValueOfColumnArray(row: r, column: c) as? Float else { return nil }
				ret.append(val)
			}
		}
		return ret
	}
	
	func cofactorSignForTopLeftOfArray() -> Sign {
		return 0 == count % 2 ? .neg : .pos
	}
	
	func determinantOfColumnArray() -> Float? {
		let cols = getSquareArrayColumnCount()
		if 0 == cols { return nil }
		switch (cols) {
		case 1:
			return (first as! Float)
		case 2:   // do the same as 3x3, 4x4?
			let a = get2x2FromSquareArray(startRow: 0, startColumn: 0)!
			return a.determinant

//			let tl = first as! Float
//			let br = last as! Float
//			let tr = self[2] as! Float
//			let bl = self[1] as! Float
//
//			let majorDiag = tl * br as Float
//			let minorDiag = tr * bl as Float
//
//			return majorDiag - minorDiag
		case 3:
			let a = get3x3FromSquareArray(startRow: 0, startColumn: 0)!
			return a.determinant
		
		case 4:
			let a = get4x4FromSquareArray(startRow: 0, startColumn: 0)!
			return a.determinant

		default:
			var s = cofactorSignForTopLeftOfArray()
			var det = Float(0);
			for col in 0..<cols {
				let cofactor = cofactorOfColumnArrayForRow(0, column: col)!  // pretty sure we've preflighted sufficiently
				det += s.rawValue * cofactor.determinantOfColumnArray()!
				s = s.nextSign()
			}
			return det
		}
	}
}

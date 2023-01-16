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
// Also appears we need to restrict ourselves to Float arrays (Extensions now support generics!!! ???)
extension Array<Float> {
	
	// returns 0 if not square.
	// Not a complete check ... e.g.
	// a 32x2 matrix has 64 elements, but is not square
	func getSquareArrayColumnCount() -> UInt {
		guard isUIntSquare(UInt(self.count)) else { return 0 }
		return UInt(sqrt(Double(self.count)))
	}

	// Indices are column first, which makes my brain hurt
	func getFloatValueOfColumnArray(row: UInt, column: UInt) -> Float? {
		let rows = getSquareArrayColumnCount() // square so rows == cols
		if (0 == rows) { return nil }		// not square
		
		let index = column * rows + row
		guard index < count else { return nil }
		
		let val: Float = self[Int(index)]
		
		print("row(\(row)) col(\(column)) -> val(\(val))")
		return val
//		return Float()
	}

	/* no point in generic because looks like larger simd arrays are always Float ... ?*/
	/* array is column-based (e.g. 2nd entry is row 2 col 1) */
	func get2x2FromSquareArray(startRow: UInt, startColumn: UInt) -> simd_float2x2? {
		if (!isUIntSquare(UInt(count))) {
			return nil
		}
		
		let test = self.getFloatValueOfColumnArray(row: startRow+1, column: startColumn+1)
		print("\(test.self)")
		
		guard let r2c2 = self.getFloatValueOfColumnArray(row: startRow+1, column: startColumn+1),
			  let r2c1 = self.getFloatValueOfColumnArray(row: startRow+1, column: startColumn),
			  let r1c2 = self.getFloatValueOfColumnArray(row: startRow, column: startColumn+1),
			  let r1c1 = self.getFloatValueOfColumnArray(row: startRow, column: startColumn)
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

		guard let r3c3 = self.getFloatValueOfColumnArray(row: startRow+2, column: startColumn+2) as? Float,
			  let r3c2 = self.getFloatValueOfColumnArray(row: startRow+2, column: startColumn+1) as? Float,
			  let r3c1 = self.getFloatValueOfColumnArray(row: startRow+2, column: startColumn) as? Float,
			  
			  let r2c3 = self.getFloatValueOfColumnArray(row: startRow+1, column: startColumn+2) as? Float,
			  let r2c2 = self.getFloatValueOfColumnArray(row: startRow+1, column: startColumn+1) as? Float,
			  let r2c1 = self.getFloatValueOfColumnArray(row: startRow+1, column: startColumn) as? Float,
			  
			  let r1c1 = self.getFloatValueOfColumnArray(row: startRow, column: startColumn+2) as? Float,
			  let r1c2 = self.getFloatValueOfColumnArray(row: startRow, column: startColumn+1) as? Float,
			  let r1c3 = self.getFloatValueOfColumnArray(row: startRow, column: startColumn) as? Float
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

		guard let r4c4 = self.getFloatValueOfColumnArray(row: startRow+3, column: startColumn+3) as? Float,
			  let r4c3 = self.getFloatValueOfColumnArray(row: startRow+3, column: startColumn+2) as? Float,
			  let r4c2 = self.getFloatValueOfColumnArray(row: startRow+3, column: startColumn+1) as? Float,
			  let r4c1 = self.getFloatValueOfColumnArray(row: startRow+3, column: startColumn) as? Float,
			  
			  let r3c4 = self.getFloatValueOfColumnArray(row: startRow+2, column: startColumn+3) as? Float,
			  let r3c3 = self.getFloatValueOfColumnArray(row: startRow+2, column: startColumn+2) as? Float,
			  let r3c2 = self.getFloatValueOfColumnArray(row: startRow+2, column: startColumn+1) as? Float,
			  let r3c1 = self.getFloatValueOfColumnArray(row: startRow+2, column: startColumn) as? Float,
			  
			  let r2c4 = self.getFloatValueOfColumnArray(row: startRow+1, column: startColumn+3) as? Float,
			  let r2c3 = self.getFloatValueOfColumnArray(row: startRow+1, column: startColumn+2) as? Float,
			  let r2c2 = self.getFloatValueOfColumnArray(row: startRow+1, column: startColumn+1) as? Float,
			  let r2c1 = self.getFloatValueOfColumnArray(row: startRow+1, column: startColumn) as? Float,
			  
			  let r1c4 = self.getFloatValueOfColumnArray(row: startRow, column: startColumn+3) as? Float,
			  let r1c3 = self.getFloatValueOfColumnArray(row: startRow, column: startColumn+2) as? Float,
			  let r1c2 = self.getFloatValueOfColumnArray(row: startRow, column: startColumn+1) as? Float,
			  let r1c1 = self.getFloatValueOfColumnArray(row: startRow, column: startColumn) as? Float
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
			if c == column { continue }
			for r in 0..<cols {  // square matrix
				if r == row { continue }
				// FIXME -- this could be optimized substantially by not calling getValueOfColumnArray
				guard let val = getFloatValueOfColumnArray(row: r, column: c) as? Float else { return nil }
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
			return (first!)
		case 2:   // do the same as 3x3, 4x4?
			/* TEMP Test */
			let tl = first!
			let br = last!
			let tr = self[2]
			let bl = self[1]

			let majorDiag = tl * br
			let minorDiag = tr * bl

			return majorDiag - minorDiag
			
//			let a = get2x2FromSquareArray(startRow: 0, startColumn: 0)!
//			return a.determinant
/*
		case 3:
			let a = get3x3FromSquareArray(startRow: 0, startColumn: 0)!
			return a.determinant

		case 4:
			let a = get4x4FromSquareArray(startRow: 0, startColumn: 0)!
			return a.determinant
*/
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

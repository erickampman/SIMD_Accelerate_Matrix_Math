//
//  Array_Extensions.swift
//  SIMD_Accelerate_Matrix_Math
//
//  Created by Eric Kampman on 1/15/23.
//

import simd
import Accelerate

// simd supports incompletely defined values, but for now I'm only allowing completely defined.
extension Array {
	
	// returns 0 if not square
	func getSquareArrayColumnCount() -> UInt {
		guard isUIntSquare(UInt(self.count)) else { return 0 }
		return UInt(sqrt(Double(self.count)))
	}

	// Indices are column first, which makes my brain hurt
	func getValueAsColumnArray(row: UInt, column: UInt) -> Element? {
		let cols = getSquareArrayColumnCount()
		if (0 == cols) { return nil }		// not square
		
		let index = column * cols + row
		guard index < count else { return nil }
		
		return self[Int(index)]
	}

	/* no point in generic because looks like larger simd arrays are always Float ... ?*/
	/* a is column-based (e.g. 2nd entry is row 2 col 1) */
	func get2x2FromSquareArray(startRow: UInt, startColumn: UInt) -> simd_float2x2? {
		if (!isUIntSquare(UInt(count))) {
			return nil
		}
		
		guard let r2c2 = self.getValueAsColumnArray(row: startRow+1, column: startColumn+1) as? Float,
			  let r2c1 = self.getValueAsColumnArray(row: startRow+1, column: startColumn) as? Float,
			  let r1c2 = self.getValueAsColumnArray(row: startRow, column: startColumn+1) as? Float,
			  let r1c1 = self.getValueAsColumnArray(row: startRow, column: startColumn) as? Float
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

		guard let r3c3 = self.getValueAsColumnArray(row: startRow+2, column: startColumn+2) as? Float,
			  let r3c2 = self.getValueAsColumnArray(row: startRow+2, column: startColumn+1) as? Float,
			  let r3c1 = self.getValueAsColumnArray(row: startRow+2, column: startColumn) as? Float,
			  
			  let r2c3 = self.getValueAsColumnArray(row: startRow+1, column: startColumn+2) as? Float,
			  let r2c2 = self.getValueAsColumnArray(row: startRow+1, column: startColumn+1) as? Float,
			  let r2c1 = self.getValueAsColumnArray(row: startRow+1, column: startColumn) as? Float,
			  
			  let r1c1 = self.getValueAsColumnArray(row: startRow, column: startColumn+2) as? Float,
			  let r1c2 = self.getValueAsColumnArray(row: startRow, column: startColumn+1) as? Float,
			  let r1c3 = self.getValueAsColumnArray(row: startRow, column: startColumn) as? Float
		else {
			return nil
		}

		let col1 = SIMD3<Float>(r1c1,r2c1,r3c1)
		let col2 = SIMD3<Float>(r1c2,r2c2,r3c2)
		let col3 = SIMD3<Float>(r1c3,r2c3,r3c3)

		return simd_float3x3(columns: (col1, col2, col3))
	}
}

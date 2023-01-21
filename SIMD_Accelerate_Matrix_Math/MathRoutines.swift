//
//  MathRoutines.swift
//  SIMD_Accelerate_Matrix_Math
//
//  Created by Eric Kampman on 1/15/23.
//

import Foundation
import simd
import Accelerate

typealias FloatArray = Array<Float>

enum Sign: Float {
	case pos = 1.0
	case neg = -1.0
	
	func nextSign() -> Sign {
		return self == .pos ? .neg : .pos
	}
}

func determinant2x2Test() {
	let r1 = SIMD2<Float>([1,2])
	let r2 = SIMD2<Float>([3,4])

	let ar1 = simd_float2x2(rows: [r1, r2])
	let ar2 = simd_float2x2(rows: [[1,2], [3,4]])

	print("ar1 type: \(ar1.self)")  // simd_float2x2([[1.0, 3.0], [2.0, 4.0]])

	let dar1 = ar1.determinant
	let dar2 = ar2.determinant

	print("determinant: \(dar2)")
	
	print("check: \(1.0 * 4.0 - 2.0 * 3.0)")
}

func determinant2x2Test2()
{
	let a: FloatArray = [1.0,3.0,2.0,4.0]	// column then row
	
	let d = a.determinantOfColumnArray()!
	print("determinant: \(d)")
}
func determinant3x3Test()
{
	// det should be 27
	
	/*
		2 3 4
	    5 6 7
	    8 9 1
		
		12 + 21*8 + 4*45 - 24*8 - 15 - 63*2
	    12 + 168  + 180  - 192 - 15 - 126
		- or -
	    2 * (6 - 63) + 5 * (3 - 36) + 8 * (21 - 24)
		2 * -57      - 5 * -33      + 8 * -3
	    -114		 + 165          + -24
	    27
		- or -
		2 * (6 - 63) - 3 * (5 - 56) + 4 * (45 - 48)
		2 * -57      - 3 * -51      + 4 * -3
		-114			153			-12
	    
	 */
	
	// columns!
	let a: FloatArray = [ 2, 5, 8,
						  3, 6, 9,
						  4, 7, 1]
	let d = a.determinantOfColumnArray()!
	print("3x3 determinant: \(d)")

}

func determinant4x4Test()
{
	// det should be -4
	
	/* UGH
	 
	  2  5 -3 -2
	 -2 -3  2 -5
	  1  3 -2  2
	 -1 -6  4  3
	 
	  -2 * DET(C1) + 5 * DET(C2) + 3 * DET(C3) - 2 * DET(C4)
	  -2 * 0      + 5 * 8      + 3 * -12      - 2 * 7
	  0           + 40         - 36           -14
	 = -4
	 */
	
	// columns!
	let a: FloatArray = [ 2, -2, 1, -1,
						  5, -3, 3, -6,
						  -3, 2, -2, 4,
						  -2, -5, 2, 3]
	
	let d = a.determinantOfColumnArray()!
	print("4x4 determinant: \(d)")
	
	let c1: FloatArray = [-3, 2, -5,  3, -2, 2, -6, 4, 3]
	let c2: FloatArray = [5, -3, -2,  3, -2, 2, -6, 4, 3]
	let c3: FloatArray = [5, -3, -2,  -3, 2, -5, -6, 4, 3]
	let c4: FloatArray = [5, -3, -2,  -3, 2, -5, 3, -2, 2]
	
	c1.debugPrint3x3ColumnArray()
	c2.debugPrint3x3ColumnArray()
	c3.debugPrint3x3ColumnArray()
	c4.debugPrint3x3ColumnArray()

	let sq3c1 = c1.get3x3FromSquareArray(startRow: 0, startColumn: 0)
	let sq3c2 = c2.get3x3FromSquareArray(startRow: 0, startColumn: 0)
	let sq3c3 = c3.get3x3FromSquareArray(startRow: 0, startColumn: 0)
	let sq3c4 = c4.get3x3FromSquareArray(startRow: 0, startColumn: 0)
	
	let dc1 = sq3c1!.determinant
	print("c1 determinant: \(dc1)")
	let dc2 = sq3c2!.determinant
	print("c2 determinant: \(dc2)")
	let dc3 = sq3c3!.determinant
	print("c3 determinant: \(dc3)")
	let dc4 = sq3c4!.determinant
	print("c4 determinant: \(dc4)")

	let tot = 2.0*dc1 + 2.0*dc2 + 1.0*dc3 + 1.0*dc4
	print("4x4 determinant: \(tot)")
}

func det3x3More() {
//	mat33 = [[11, 12, -13],
//	         [21,-22,  23],
//          [-31, 32,  33]]
// det -32824
	
	let col1 = SIMD3<Float>(11,21,-31)
	let col2 = SIMD3<Float>(12,-22,32)
	let col3 = SIMD3<Float>(-13,23,33)
	
	let square3 = simd_float3x3(columns: (col1, col2, col3))
	let d = square3.determinant
	print("3x3 determinant: \(d)")  // correct
	
	let cola: [Float] = [11,21,-31, 12,-22,32, -13,23,33]
	
	let sq3too = cola.get3x3FromSquareArray(startRow: 0, startColumn: 0)
	let c1 = sq3too?.columns.0
	let c2 = sq3too?.columns.1
	let c3 = sq3too?.columns.2
	print("3x3 col1 = \(String(describing: c1))")
	print("3x3 col2 = \(String(describing: c2))")
	print("3x3 col3 = \(String(describing: c3))")

	let d2 = sq3too!.determinant
	print("3x3 determinant check: \(d2)")  // correct
}

func determinant5x5Test()
{
	// Have the answer: -34.0 from Schaum
	
	// columns!
	let a: FloatArray = [ 6, 2, 1, 3, -1,
						  2, 1, 1, 0, -1,
						  1, 1, 2, 2, -3,
						  0, -2, -2, 3, 4,
						  5, 1, 3, -1, 2]
	
	let d = a.determinantOfColumnArray()!
	print("5x5 determinant: \(d)")   // currently incorrect!
}

/* probably good enough for the sizes of matrices I will be using, but ...*/
func isUIntSquare(_ val: UInt) -> Bool {
	let root: Double = sqrt(Double(val))
	return root * root == Double(val)
}

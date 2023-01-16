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
	
	// columns!
	let a: FloatArray = [ 2, 5, 8,
						  3, 6, 9,
						  4, 7, 1]
	let d = a.determinantOfColumnArray()!
	print("determinant: \(d)")

}

func determinant4x4Test()
{
	// det should be -4
	
	// columns!
	let a: FloatArray = [ 2, -2, 1, -1,
						  5, -3, 3, -6,
						  -3, 2, -2, 4,
						  -2, -5, 2, 3]
	
	let d = a.determinantOfColumnArray()!
	print("determinant: \(d)")
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
	print("determinant: \(d)")   // currently incorrect!
}

/* probably good enough for the sizes of matrices I will be using, but ...*/
func isUIntSquare(_ val: UInt) -> Bool {
	let root: Double = sqrt(Double(val))
	return root * root == Double(val)
}

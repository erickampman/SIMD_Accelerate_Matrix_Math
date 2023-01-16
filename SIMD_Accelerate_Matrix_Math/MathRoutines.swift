//
//  MathRoutines.swift
//  SIMD_Accelerate_Matrix_Math
//
//  Created by Eric Kampman on 1/15/23.
//

import Foundation
import simd
import Accelerate

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

/* probably good enough for the sizes of matrices I will be using, but ...*/
func isUIntSquare(_ val: UInt) -> Bool {
	let root: Double = sqrt(Double(val))
	return root * root == Double(val)
}

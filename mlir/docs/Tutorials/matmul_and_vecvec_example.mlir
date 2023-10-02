func.func private @printMemrefF32(memref<*xf32>)

func.func @matmul(%A: memref<?x?xf32>, %B: memref<?x?xf32>) -> (memref<?x?xf32>) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %f0 = arith.constant 0.0 : f32
  %x = memref.dim %A, %c0 : memref<?x?xf32>
  %y = memref.dim %B, %c1 : memref<?x?xf32>
  %C = memref.alloc(%x, %y) : memref<?x?xf32>
  linalg.fill ins(%f0 : f32) outs(%C : memref<?x?xf32>)
  linalg.matmul ins(%A, %B: memref<?x?xf32>, memref<?x?xf32>)
                outs(%C: memref<?x?xf32>)
  return %C : memref<?x?xf32>
}

func.func @vecvec(%A: memref<?xf32>, %B: memref<?xf32>) -> (memref<f32>) {
  %f0 = arith.constant 0.0 : f32
  %v = memref.alloc() : memref<f32>
  linalg.vecvec ins(%A, %B: memref<?xf32>, memref<?xf32>)
                  outs(%v: memref<f32>)
  return %v: memref<f32>
}

func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %m = arith.constant 5 : index
  %x = arith.constant 3 : index
  %n = arith.constant 2 : index
  %val1 = arith.constant 13.0 : f32
  %val2 = arith.constant 17.0 : f32
  %A = memref.alloc(%m, %x) : memref<?x?xf32>
  %B = memref.alloc(%x, %n) : memref<?x?xf32>
  %G = memref.alloc(%n) : memref<?xf32>
  linalg.fill ins(%val1 : f32) outs(%A : memref<?x?xf32>)
  linalg.fill ins(%val2 : f32) outs(%B : memref<?x?xf32>)
  linalg.fill ins(%val2 : f32) outs(%G : memref<?xf32>)
  memref.store %val1, %B[%c0, %c0] : memref<?x?xf32>
  %C1 = call @matmul(%A, %B) : (memref<?x?xf32>, memref<?x?xf32>) -> memref<?x?xf32>
  %C2 = call @vecvec(%G, %G) : (memref<?xf32>, memref<?xf32>) -> memref<f32>
  %C2_ = memref.cast %C2 : memref<f32> to memref<*xf32>
  call @printMemrefF32(%C2_) : (memref<*xf32>) -> ()
  memref.dealloc %C1 : memref<?x?xf32>
  memref.dealloc %C2 : memref<f32>
  memref.dealloc %G : memref<?xf32>
  return
}


open Ctypes

module C(F: Cstubs.FOREIGN) = struct

  type bitset_s
  let bitset_s : bitset_s structure typ = structure "bitset_s" 
  let array     = field bitset_s "array" (ptr uint64_t)
  let arraysize = field bitset_s "arraysize" size_t
  let capacity  = field bitset_s "capacity" size_t
  let () = seal bitset_s

  let bitset_t  = typedef bitset_s "bitset_t"
  let pbts      = ptr bitset_t

  let create    = F.(foreign "bitset_create" (void @-> returning pbts))
  let create_with_capacity = F.(foreign "bitset_create_with_capacity" (size_t @-> returning pbts))
  let copy      = F.(foreign "bitset_copy" (pbts @-> returning pbts))

  let clear     = F.(foreign "bitset_clear" (pbts @-> returning void))
  let free      = F.(foreign "bitset_free" (pbts @-> returning void))
  let resize    = F.(foreign "bitset_resize" (pbts @-> size_t @-> bool @-> returning bool))

  let size_in_bytes = F.(foreign "bitset_size_in_bytes" (pbts @-> returning size_t))        
  let size_in_bits  = F.(foreign "bitset_size_in_bits" (pbts @-> returning size_t))        
  let size_in_words = F.(foreign "bitset_size_in_words" (pbts @-> returning size_t))        

  let grow      = F.(foreign "bitset_grow" (pbts @-> size_t @-> returning bool))
  let set       = F.(foreign "bitset_set" (pbts @-> size_t @-> returning void))
  let get       = F.(foreign "bitset_get" (pbts @-> size_t @-> returning bool))

  let count     = F.(foreign "bitset_count" (pbts @-> returning size_t))
  let minimum   = F.(foreign "bitset_minimum" (pbts @-> returning size_t))
  let maximum   = F.(foreign "bitset_maximum" (pbts @-> returning size_t))

  let inplace_union   = F.(foreign "bitset_inplace_union" (pbts @-> pbts @-> returning bool))
  let union           = F.(foreign "bitset_union" (pbts @-> pbts @-> returning pbts))
  let union_count     = F.(foreign "bitset_union_count" (pbts @-> pbts @-> returning size_t))

  let inplace_intersection   = F.(foreign "bitset_inplace_intersection" (pbts @-> pbts @-> returning void))
  let intersection_count = F.(foreign "bitset_intersection_count" (pbts @-> pbts @-> returning size_t))

  let inplace_difference = F.(foreign "bitset_inplace_difference" (pbts @-> pbts @-> returning void))
  let difference_count = F.(foreign "bitset_difference_count" (pbts @-> pbts @-> returning size_t))

  let inplace_symmetric_difference = F.(foreign "bitset_inplace_symmetric_difference" (pbts @-> pbts @-> returning bool))
  let symmetric_difference_count = F.(foreign "bitset_symmetric_difference_count" (pbts @-> pbts @-> returning size_t))

end

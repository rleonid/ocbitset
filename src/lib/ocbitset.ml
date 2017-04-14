
open Ctypes

module C = Cbitset_bindings.C(Cbitset_generated)

(*type t = C.bitset_s Ctypes.structure Ctypes_static.ptr *)
type t = C.bitset_s Ctypes.structure Ctypes.ptr ref

let in_ref p =
  let r = ref p in
  Gc.finalise (fun r -> C.free !r) r;
  r

let create s =
  if s < 0 then
    invalid_arg (Printf.sprintf "Ocbitset.create, size %d less than zero." s)
  else
    in_ref ( C.create_with_capacity (Unsigned.Size_t.of_int s)) 

let capacity t =
  Unsigned.Size_t.to_int (C.size_in_bits !t)

let cardinal t =
  Unsigned.Size_t.to_int (C.count !t)

let set t i =
  if i < 0 then
    invalid_arg (Printf.sprintf "Ocbitset.set, index %d less than zero." i)
  else
    C.set !t (Unsigned.Size_t.of_int i)
 
let get t i =
  if i < 0 then
    invalid_arg (Printf.sprintf "Ocbitset.get, index %d less than zero." i)
  else
    C.get !t (Unsigned.Size_t.of_int i)
 
let union t1 t2 =
  in_ref (C.union_copy !t1 !t2)
  (*
  let c = in_ref (C.copy !t1) in
  ignore (C.inplace_union !c !t2); (* TODO: Do not ignore *)
  c *)


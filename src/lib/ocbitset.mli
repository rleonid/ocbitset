
type t

val create : int -> t

val capacity : t -> int

val cardinal : t -> int

val set : t -> int -> unit

val get : t -> int -> bool

val union : t -> t -> t

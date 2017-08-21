module type OrderedType =
  sig
    type t
    val compare : t -> t -> int
  end

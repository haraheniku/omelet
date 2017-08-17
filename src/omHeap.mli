module type OrderedType =
  sig
    type t
    val compare : t -> t -> int
  end

module type S =
  sig
    type el
    type t
    val empty : t
    val add : t -> el -> t
    val merge : t -> t -> t
    val top : t -> el option
    val remove : t -> t
    val of_list : el list -> t
  end

module Make (Ord : OrderedType) : S with type el = Ord.t

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
    val to_list : t -> el list
  end

module Make (Ord : OmInterfaces.OrderedType) : S with type el = Ord.t

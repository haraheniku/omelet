(* leftist heap *)
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

module Make(Ord: OmInterfaces.OrderedType) = struct
  type el = Ord.t

  type t =
    | Empty
    | Node of int * el * t * t

  let empty = Empty

  let rank = function
    | Empty -> 0
    | Node (rk, _, _, _) -> rk

  let add_node x l r =
    if rank l >= rank r then
      Node (rank r + 1, x, l, r)
    else
      Node (rank l + 1, x, r, l)

  let rec merge h1 h2 =
    match (h1, h2) with
    | (h, Empty) -> h
    | (Empty, h) -> h
    | (Node (_, x, l1, r1), Node (_, y, l2, r2)) ->
        if Ord.compare x y <= 0 then
          add_node x l1 (merge r1 h2)
        else
          add_node y l2 (merge h1 r2)

  let rec add h x =
    match h with
    | Empty -> Node (1, x, Empty, Empty)
    | Node (_, y, l, r) as n ->
        if Ord.compare x y <= 0 then
          add_node x n Empty
        else
          add_node y l (add r x)

  let top = function
    | Empty -> None
    | Node (_, x, _, _) -> Some x

  let remove = function
    | Empty -> failwith "remove"
    | Node (_, _, l, r) -> merge l r

  let of_list l = List.fold_left add Empty l

  let rec to_list = function
    | Empty -> []
    | Node (_, x, l, r) ->
        x :: to_list (merge l r)
end

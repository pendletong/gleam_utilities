import gleam/list
import gleam/option.{type Option, None, Some}

fn do_map(
  list: List(a),
  fun: fn(Option(a), a, Option(a)) -> b,
  prev: Option(a),
  acc: List(b),
) -> List(b) {
  case list {
    [] -> list.reverse(acc)
    [x, y, ..xs] ->
      do_map([y, ..xs], fun, Some(x), [fun(prev, x, Some(y)), ..acc])
    [x] -> do_map([], fun, Some(x), [fun(prev, x, None), ..acc])
  }
}

/// Returns a new list containing only the elements of the first list after the
/// function has been applied to each one. Provided Function takes a sliding window
/// of previous, current, next element of which previous and next are optional
///
/// ## Examples
///
/// ```gleam
/// map([2, 4, 6], fn(x) { x * 2 })
/// // -> [4, 8, 12]
/// ```
///
pub fn map_with_window(
  list: List(a),
  with fun: fn(Option(a), a, Option(a)) -> b,
) -> List(b) {
  do_map(list, fun, None, [])
}

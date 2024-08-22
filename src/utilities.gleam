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
/// map_with_window([2, 4, 6], fn(prev, cur, next) { case prev, next {
///   Some(_), Some(_) -> cur * 2
///   Some(_), None -> cur + 50
///   None, Some(_) -> cur * 3
///   None, None -> cur - 10
/// }
///  })
/// // -> [6, 8, 56]
/// ```
///
pub fn map_with_window(
  list: List(a),
  with fun: fn(Option(a), a, Option(a)) -> b,
) -> List(b) {
  do_map(list, fun, None, [])
}

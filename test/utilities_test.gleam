import gleam/list
import gleam/option.{None, Some}
import gleeunit
import gleeunit/should
import utilities

@target(erlang)
const recursion_test_cycles = 1_000_000

// JavaScript engines crash when exceeding a certain stack size:
//
// - Chrome 106 and NodeJS V16, V18, and V19 crash around 10_000+
// - Firefox 106 crashes around 35_000+.
// - Safari 16 crashes around 40_000+.
@target(javascript)
const recursion_test_cycles = 40_000

pub fn main() {
  gleeunit.main()
}

pub fn map_test() {
  []
  |> utilities.map_with_window(fn(_p, c, _n) { c * 2 })
  |> should.equal([])

  [1]
  |> utilities.map_with_window(fn(p, c, n) { #(p, c, n) })
  |> should.equal([#(None, 1, None)])

  [1, 2]
  |> utilities.map_with_window(fn(p, c, n) { #(p, c, n) })
  |> should.equal([#(None, 1, Some(2)), #(Some(1), 2, None)])

  [1, 2, 3]
  |> utilities.map_with_window(fn(p, c, n) { #(p, c, n) })
  |> should.equal([
    #(None, 1, Some(2)),
    #(Some(1), 2, Some(3)),
    #(Some(2), 3, None),
  ])

  [0, 4, 5, 7, 3]
  |> utilities.map_with_window(fn(_p, c, _n) { c * 2 })
  |> should.equal([0, 8, 10, 14, 6])

  // TCO test
  list.repeat(0, recursion_test_cycles)
  |> utilities.map_with_window(fn(_p, c, _n) { c })
}

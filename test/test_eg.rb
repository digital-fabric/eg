# frozen_string_literal: true

require 'modulation'
require 'minitest/autorun'

EG = import '../lib/eg'

class EGTest < MiniTest::Test
  def test_that_eg_can_define_methods
    m = EG.(a: ->(x) { x + 1 }, b: ->(x) { x * 2})
    assert_equal(4, m.a(3))
    assert_equal(6, m.b(3))
  end

  def test_that_eg_can_define_constants
    m = EG.(A: 1, B: 2)
    assert_equal(1, m::A)
    assert_equal(2, m::B)
  end

  def test_that_eg_constants_are_accessible_from_methods
    m = EG.(A: 1, a: ->(x) { x + self::A })
    assert_equal(4, m.a(3))
  end

  def test_that_eg_accepts_attributes
    m = EG.("@foo": 'bar', getattr: -> { @foo })
    
    assert_equal('bar', m.getattr)
  end

  def test_the_works
    effect = ->(f) {
      EG.(
        map:          ->(g)  { effect.(->(*x) {g.(f.(*x))}) },
        run_effects:  ->(*x) { f.(*x) },
        join:         ->(*x) { f.(*x) },
        chain:        ->(g)  { effect.(f).map(g).join() }
      )
    }

    msgs = []
    f_zero = ->() {
      msgs << 'Starting with nothing'
      0
    }
    zero = effect.(f_zero)
    increment = ->(x) { x + 1 }
    one = zero.map(increment)

    assert_equal([], msgs)
    assert_equal(1, one.run_effects)
    assert_equal(['Starting with nothing'], msgs)

    msgs.clear
    double  = ->(x) { x * 2 }
    cube    = ->(x) { x**3 }
    eight = zero.map(increment).map(double).map(cube)
    
    assert_equal([], msgs)
    assert_equal(8, eight.run_effects)
    assert_equal(['Starting with nothing'], msgs)
  end

  def test_use_as_proc
    Kernel.define_method(:eg, &EG)
    o = eg(
      foo: -> { :bar }
    )
    assert_equal(:bar, o.foo)
  end
end
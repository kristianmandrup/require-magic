require "test/unit"

class UnitTestRequire < Test::Unit::TestCase

  def setup
    @folders = ['data', 'data2']
    @folder = 'data'
  end

  def match?(expr, rexp)    
    !(expr =~ /#{Regexp.escape(rexp)}/).nil?
  end
  
  def test_me
    assert true, "true"
  end
end
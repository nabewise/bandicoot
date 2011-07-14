require File.join(File.dirname(__FILE__), "helper")

class BandicootTest < Test::Unit::TestCase

  def teardown
    FakeFS::FileSystem.clear
  end

  def test_start
    started = false
    Bandicoot.start do
      started = true
      assert Bandicoot.current
    end
    assert started
  end

  def test_start_with_custom_path
    Bandicoot.start(:save_file => "blah") do
      1+1
    end
    assert File.exists?("blah")
  end

  def test_start_with_continue
    File.open("blah", "w").close
    Bandicoot.start(:continue => false) do
      assert !Bandicoot.current.continuing?
    end

    Bandicoot.start(:continue => "blah") do
      assert Bandicoot.current.continuing?
    end
  end

  def test_save_point
    run_count = 0
    Bandicoot.start(:save_file => "blah") do
      x = Bandicoot.save_point(:incr) do
        run_count += 1
        42
      end
      assert_equal 42, x
    end

    Bandicoot.start(:continue => "blah") do
      x = Bandicoot.save_point("incr") do
        run_count += 1
        42
      end
      assert_equal 42, x
    end

    assert_equal 1, run_count
  end
end


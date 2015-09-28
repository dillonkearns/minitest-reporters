require_relative "../../test_helper"

module MinitestReportersTest
  class KataReporterTest < Minitest::Test
    def setup
      @reporter = Minitest::Reporters::KataReporter.new
      @test = Minitest::Test.new("")
      @test.time = 0
    end

    def test_removes_underscore_in_name_if_spec_style
      @test.name = "test_0009_converts 24 to XXIV"
      assert_output /\s+converts 24 to XXIV/ do
        @reporter.io = $stdout
        @reporter.record(@test)
      end
    end

    def test_wont_modify_name_if_not_spec_style
      @test.name = "test_foo"
      assert_output /test_foo/ do
        @reporter.io = $stdout
        @reporter.record(@test)
      end
    end
  end
end

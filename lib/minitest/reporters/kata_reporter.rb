class Minitest::Test
  # force minitest not to run tests in order for better readability
  i_suck_and_my_tests_are_order_dependent!
end

module Minitest
  module Reporters
    # Spec-style reporter that guides you through the steps
    # of TDD.
    #
    class KataReporter < BaseReporter
      include ANSI::Code
      include RelativePosition

      KATA_QUOTES = [
        "In the beginner’s mind there are many possibilities, but in the expert’s there are few.\nThe goal of practice is always to keep our beginner’s mind.", #  - Shunryu Suzuki, Zen Mind, Beginner's Mind
        "Do not dwell on the past, do not live in the future, concentrate the mind on the present moment.",
      ]

      def start
        super
      end

      def kata_wisdom
        KATA_QUOTES.shuffle.first
      end

      def report
        super

        if failures.zero? && errors.zero?
          puts underline bold green('GREEN')
          puts("(%d tests, %d assertions)\n" % [count, assertions])
          puts cyan("\"#{kata_wisdom}\"\n\n")

          puts underline "Choose your next step\n"
          puts "1) %s\n   %s\n\n" % [bold('REFACTOR'), 'Look for duplication in existing logic without adding new functionality.']
          puts "2) %s\n   %s" % [bold('RED     '), 'Write a failing test to triangulate new functionality or test edge cases.']
          puts "   Don't forget, you have #{yellow('%d skipped tests')} waiting to be implemented." % skips if skips > 0
        else
          puts underline bold red('RED')
          puts("#{red('%d failures, %d errors')} (%d tests, %d assertions)\n" % [failures, errors, count, assertions])
          puts underline "Your task now is\n"
          puts bold "GREEN"
          puts "   Make the SIMPLEST change to make the test pass"
          puts "   - Don't anticipate the complete solution"
          puts "   - Only focus on the current failing test"
        end
      end

      def print_info(e, name=true)
        e.message.each_line { |line|
          line = line.gsub(/Expected: (\S+)/) { |expected| yellow('Expected: ') + cyan($1) }.
          gsub(/Actual: (\S+)/) { |expected| magenta('Actual: ') + cyan($1) }
          print_with_info_padding(line)
        }
        puts

        # When e is a Minitest::UnexpectedError, the filtered backtrace is already part of the message printed out
        # by the previous line. In that case, and that case only, skip the backtrace output.
        unless e.is_a?(MiniTest::UnexpectedError)
          trace = filter_backtrace(e.backtrace)
          trace.each { |line| print_with_info_padding(line) }
        end
      end

      def record(test)
        super
        print pad_test(test.name.gsub(/test_\d+_/, ''))
        print_colored_status(test)
        puts
        if !test.skipped? && test.failure
          print_info(test.failure)
          puts
        end
      end

      protected

      def before_suite(suite)
        puts suite
      end

      def after_suite(suite)
        puts
      end
    end
  end
end

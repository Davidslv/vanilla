require_relative 'lib/vanilla'

result = Vanilla::Debug.load_game
if result[:error]
  puts "\nTest failed!"
  puts "Error: #{result[:message]}"
  puts "\nDetails:"
  if result[:details]
    result[:details].each do |error|
      puts "\n- Test: #{error[:test]}"
      puts "  Expected: #{error[:expected]}"
      puts "  Actual: #{error[:actual]}"
      puts "  From: #{error[:from]}"
      puts "  Message: #{error[:message]}"
    end
  end
else
  puts "\nAll tests passed!"
  puts "Game state verified successfully"
end 
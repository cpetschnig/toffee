# This part was very much inspired by Jan Lelis and his talk at RUG-B on
# August 5th, 2010
# Find his code at http://github.com/janlelis/zucker/blob/master/lib/zucker/D.rb

# Copyright (c) 2010 Jan Lelis

module Kernel

  # TODO: check, if there is already a method named d
  # show a warning in that case!

  def d(*args)
    if args.empty?
      tap do
        Toffee.output(block_given? ? yield(self) : self.inspect)
      end
    else
      raise ArgumentError, "Toffee: .d - The parser thought that the code after .d are method arguments... Please don't put a space after d or use .d() or .d{} in this case!"
#      eval ...
    end
  end

end
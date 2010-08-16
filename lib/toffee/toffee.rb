module Toffee

  DEFAULT_TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M:%S '

  # There are several ways, where debugging output can be directed to:
  # STDOUT, :stdout     Standard out is the default destination
  # Any other Object that responds to :puts
  # A filename; append to this file using system command `echo "foo" >> /tmp/my-file
  # A logger object, that responds to the second argument

  class << self

    # Set up the default configuration
    def init_configuration #:nodoc:
      @@configuration ||= {:target => STDOUT, :target_type => :io}
    end

    # Configure the output:
    #
    # Toffee will per default write to standard output. There are two ways to
    # force this behavior:
    #
    #  Toffee.configure(STDOUT)
    # or
    #  Toffee.configure(:stdout)
    #
    # Write the output to any object, that implements a <tt>:puts</tt> method:
    #
    #  Toffee.configure(IO.new(2, 'w'))
    #
    # Or any object that implements a <tt>:debug</tt> method:
    #
    #  Toffee.configure(Rails.logger)
    #
    # You can also supply your method, that will get called. Pass it as the
    # second parameter:
    #
    #  Toffee.configure(Rails.logger, :info)
    #
    # Sometimes it comes very handy to log to a file. Just pass a string with
    # the filename to write to:
    #
    #  Toffee.configure('/tmp/foo.log')
    #  
    # Toffee will then use a shell command like the following to write to the
    # file:
    #
    #   $ echo "my output here" > /tmp/foo.log
    #
    # <b>More options</b>
    #
    # [<tt>:timestamp</tt>]  prepend a timestamp on each log message use true to
    #                        turn logging on; turn it off by passing nil or
    #                        false; pass a string value to supply a custom
    #                        format (like with <tt>Time.strftime</tt>); default
    #                        is true
    #
    def configure(*args)
      raise ArgumentError if args.empty?

      unless args.first.kind_of?(Hash)
        target = args.delete_at(0)
        method = args.delete_at(0) unless args.empty? || args.first.kind_of?(Hash)
        method.to_sym if method.kind_of?(String)
        raise TypeError.new("Argument two should be kind'a Symbol.") if method && !method.kind_of?(Symbol)
      end

      options = args.last || {}

      init_configuration

      if target
        @@configuration[:target_type], @@configuration[:target],
          @@configuration[:method] = if [STDOUT, :stdout].include?(target)
          [:io, STDOUT]
        elsif target.respond_to?(:puts)
          [:io, target]
        elsif target.kind_of?(String)
          raise IOError.new("Cannot write to file '#{target}'.") unless File.writable?(target) || File.writable?(File.dirname(target))
          [:file, target]
        elsif (method)
          if target.respond_to?(method)
            [:logger, target, method]
          else
            raise ArgumentError.new("Target object does not respond to method :#{method}.")
          end
        else # no method was given
          if target.respond_to?(:debug)
            [:logger, target, :debug]
          else
            raise TypeError.new("Target object does not respond to method :debug.")
          end
        end
      end

      # TODO: implement much, much more features

      # option :timestamp
      if options.key?(:timestamp)
        timestamp = options.delete(:timestamp)
        @@configuration[:timestamp] = timestamp
        @@configuration[:timestamp_format] = timestamp if timestamp.kind_of?(String)
      end


      # option :with_file_position

      # option :stacktrace
      
      # option :prefix, :suffix

      self
    end

    # Truncate the output file to zero length
    def clear
      init_configuration
      return unless @@configuration[:target_type] == :file
      %x{echo -n > #{@@configuration[:target]}}
    end

    # Write to STDOUT, or to the destination that was configured with
    # <tt>Toffee.configure</tt>
    def output(string)
      init_configuration

      string = prepend_timestamp(string) if @@configuration[:timestamp]
      
      case @@configuration[:target_type]
      when :io then @@configuration[:target].puts(string)
      when :file then %x{echo "#{string.gsub('"', '\\"')}" >> #{@@configuration[:target]}}
      when :logger then @@configuration[:target].send(@@configuration[:method], string)
      end
    end

    private

    def prepend_timestamp(string)
      Time.new.strftime(@@configuration[:timestamp_format] || DEFAULT_TIMESTAMP_FORMAT) << string
    end
    
  end

end
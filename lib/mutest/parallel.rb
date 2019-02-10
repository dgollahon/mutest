module Mutest
  # Parallel execution engine of arbitrary payloads
  module Parallel
    # Driver for parallelized execution
    class Driver
      include Concord.new(:binding)

      # Scheduler status
      #
      # @return [Object]
      def status
        binding.call(__method__)
      end

      # Stop master gracefully
      #
      # @return [self]
      def stop
        binding.call(__method__)
        self
      end
    end

    # Run async computation returning driver
    #
    # @return [Driver]
    def self.async(config)
      Driver.new(config.env.new_mailbox.bind(Master.call(config)))
    end

    # Job result sink
    class Sink
      include AbstractType

      # Process job result
      #
      # @param [Object]
      #
      # @return [self]
      abstract_method :result

      # Sink status
      #
      # @return [Object]
      abstract_method :status

      # Test if processing should stop
      #
      # @return [Boolean]
      abstract_method :stop?
    end

    # Job to push to workers
    class Job
      include Anima.new(
        :index,
        :payload
      )
      include Adamantium::Flat
    end

    # Job result object received from workers
    class JobResult
      include Anima.new(
        :job,
        :payload
      )
      include Adamantium::Flat
    end

    # Parallel run configuration
    class Config
      include Anima.new(
        :env,
        :jobs,
        :processor,
        :sink,
        :source
      )
      include Adamantium::Flat
    end

    # Parallel execution status
    class Status
      include Anima.new(
        :active_jobs,
        :done,
        :payload
      )
      include Adamantium::Flat
    end
  end
end

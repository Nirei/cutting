# frozen_string_literal: true

module Cutting
  # Allows thread-level parallelization of tasks to speed up blocking I/O operations
  # Use it like this:
  #
  # ```
  # ThreadPool.new(8) do |pool|
  #   pool.run do
  #     # concurrent code
  #   end
  # end
  # ```
  class ThreadPool
    class IllegalStateError < StandardError
    end

    def initialize(threads)
      raise ArgumentError, "wrong number of threads #{threads}, must be a positive integer" unless threads.positive?

      @parent = Thread.current
      @threads = threads
      @idle = []
      Array.new(threads) { create_acceptor }
      # wait until all threads are started
      Thread.stop while idle.size < @threads

      # execute concurrent code
      yield self

      # wait until all threads are finished
      Thread.stop while idle.size < @threads
      # kill remaining threads
      idle.each(&:kill)
      @threads = 0
    end

    def run(&block)
      raise IllegalStateError, "call #run only from inside the block passed to #new" if threads.zero?

      Thread.stop while idle.empty?
      idle.pop.run(block)
    end

    private

    def create_acceptor
      Acceptor.new do |acceptor|
        # return acceptor to the idle queue after each job
        idle << acceptor
        # wake up parent
        parent.wakeup
      end
    end

    attr_reader :parent
    attr_reader :threads
    attr_reader :idle

    # Simple class to accept jobs and execute them inside a reusable thread, the block given to the initializer will be
    # called every time a job finishes execution
    class Acceptor
      def initialize
        @thread =
          Thread.new do
            loop do
              # call finishing callback
              yield self
              # go to sleep, wait for next job
              Thread.stop if job.nil?
              # execute job
              job.call
              @job = nil
            end
          end
        @job = nil
      end

      def run(block)
        self.job = block
        thread.wakeup
      end

      def kill
        thread.kill
      end

      private

      attr_accessor :thread
      attr_accessor :job
    end
  end
end

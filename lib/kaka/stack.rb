module Kaka
  class Stack

    def initialize
      @stack = []
    end

    def current
      @stack.last || :default
    end

    def push(state)
      @stack.push(state)
    end

    def pop
      @stack.pop
    end

  end
end

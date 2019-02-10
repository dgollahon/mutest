module MutestSpec
  class FileState
    DEFAULTS = IceNine.deep_freeze(
      file:     false,
      contents: nil,
      requires: []
    )

    include Anima.new(*DEFAULTS.keys)
    include Adamantium

    def self.new(attributes = DEFAULTS)
      super(DEFAULTS.merge(attributes))
    end

    DOES_NOT_EXIST = new

    alias_method :file?, :file
  end

  class FakePathname
    include Concord.new(:file_system, :pathname)
    include Adamantium

    def join(*arguments)
      self.class.new(
        file_system,
        pathname.join(*arguments)
      )
    end

    def read
      state.contents
    end

    def to_s
      pathname.to_s
    end

    def file?
      state.file?
    end

    private

    def state
      file_system.state(pathname.to_s)
    end
  end

  class FileSystem
    include Concord.new(:file_states)
    include Adamantium

    def state(filename)
      file_states.fetch(filename, FileState::DOES_NOT_EXIST)
    end

    def path(filename)
      FakePathname.new(self, Pathname.new(filename))
    end
  end
end

module Consular
  class Terminator
    module Version
      MAJOR = 0
      MINOR = 1
      PATCH = 0
      BUILD = nil
    end

    VERSION = [
      Version::MAJOR, Version::MINOR, Version::PATCH, Version::BUILD
    ].compatch.join('.')
  end
end

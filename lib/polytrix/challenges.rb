module Polytrix
  class Challenges < Hash
    def get(regex)
      _, v = find do |k, _|
        regex.match k
      end
      v
    end

    def get_all(regex)
      select do |k, _|
        regex.match k
      end.values
    end
  end
end

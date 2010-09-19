class GitoliteConfPerms
  def initialize()
    @data = Hash.new { |hash, key| hash[key] = [] }
  end
  def [](key)
    @data[key]
  end
  def []=(key,words)
    @data[key] += [words].flatten
    @data[key].uniq!
  end
  def empty?()
    @data.empty?
  end
  def each
    @data.each do |key, value|
      yield key, value
    end
  end
end

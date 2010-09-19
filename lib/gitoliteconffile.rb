# This class represents a Gitolite .conf file
require 'gitoliteconfperms'

class GitoliteConfFile
  def self.load( filename, opts = {} )
    new(filename, opts)
  end

  def initialize( filename )
    @fn = filename
    @groups =  Hash.new { |hash, key| hash[key] = [] }
    @repos =  Hash.new { |hash, key| hash[key] = [] }

    @rgxp_comment = %r/\A\s*\z|\A\s*#.*/
    @rgxp_group = %r/^(@\S+)\s*=\s*(.*)/
    @rgxp_repo = %r/^\A\s*repo\s(.*)/
    @rgxp_perm = %r/^\A\s*(-|C|R|RW\+?(?:C?D?|D?C?))\s(.*\s)?=\s(.+)/

  end

  def [](repo_name)
    if @repos[repo_name].nil? or @repos[repo_name].empty?
      @repos[repo_name] = GitoliteConfPerms.new()
    end
    @repos[repo_name]
  end

  def []=(repo_name, perms)
    if perms.nil?
      @repos[repo_name] = GitoliteConfPerms.new() if @repos[repo_name].empty?
    else
      @repos[repo_name] = perms
    end
  end

  def parse
    return unless File.file?(@fn)
    section = nil

    File.open(@fn, 'r') do |f|
      while line = f.gets
        line = line.chomp
        case line
        # ignore blank lines and comment lines
        when @rgxp_comment;

        when @rgxp_group
          begin
            # Get group name and list of members
            @groups[$1.strip] = $2.split(/ /)
          end
        when @rgxp_repo;
          begin
            repo_list = $1
          end

        when @rgxp_perm
          begin
            repo_list.each(' ') do |repo|
              permission = $1.strip
              user_list = $3.strip
              @repos[repo.strip] = GitoliteConfPerms.new() if @repos[repo.strip].empty?
              $3.each(' ') do |user|
                @repos[repo.strip][permission] = user
              end
            end
          end
        end
      end
    end
  end

  def create
    return unless File.file?(@fn)

    File.open(@fn, 'w') do |f|
      @repos.each do |repo_name, perms|
        f.puts "repo" + "\t" + repo_name
        perms.each do |perm, user_list|
          f.puts "\t\t" + perm + " = " + user_list.join(' ')
        end
        f.puts

      end
    end
  end

end



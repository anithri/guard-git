module Guard
  module GitExtension
    module AutoBranch
      AUTO_BRANCH_OPTIONS =
          { :auto_branch => false,
            :auto_branch_options => {
              :name => false,
              :prefix => "auto/",
              :suffix => nil,
              :separator => "",
              :merge_back => true
          }
      }

      def self.included(base)
        base.add_to_options(AUTO_BRANCH_OPTIONS)
        base.add_to_run_list(:start, :start_auto_branch, :ok_to_auto_branch? )
      end

      def start_auto_branch
        @orig_branch_name = @repo.head.name
        @auto_branch_name = auto_branch_name(@orig_branch_name)
        if ok_to_branch?
          branch_to(@auto_branch_name)
        else
          @options[:auto_branch_options][:disabled] = true
        end
      end

      def ok_to_auto_branch?
        @options[:auto_branch] && ! @options[:auto_branch_options].fetch(:disabled, false)
      end

      def auto_branch_name(orig_name)
        new_branch = @options[:auto_branch_options][:name] || computed_branch_name(orig_name) || ""
      end

      def computed_branch_name(orig_name)
        parts = [
            @options[:auto_branch_options][:prefix],
            orig_name,
            @options[:auto_branch_options][:suffix]
        ]
        parts.compact.join(@options[:auto_branch_options][:separator])
      end

      def ok_to_branch?
        head = "Guard::Git not branching."
        if @auto_branch_name.empty?
          UI.warning "#{head} No valid new branch name exists."
          return false
        elsif @auto_branch_name == @orig_branch_name
          UI.warning "#{head} New branch name is same as original."
          return false
        elsif @repo.get_head(@auto_branch_name)
          UI.warning "#{head} New branch name already exists: #{@auto_branch_name}"
          return false
        else
          return true
        end
      end

      def branch_to(new_branch)
        `git --git-dir=#{@repo.path} checkout -q -b #{new_branch}`
      end
    end
  end
end

module Guard
  module GitExtension
    module Status
      SUMMARY_OPTIONS = {:status => true}

      def self.included(base)
        base.add_to_options(SUMMARY_OPTIONS)
        [:start, :run_all, :run_on_change, :run_on_deletion].each do |type|
          base.add_to_run_list(type, :status_summary, :ok_to_run_summary?)
        end
      end

      def ok_to_run_summary?
        @options[:status]
      end

      def status_summary
        UI.info @repo.status_summary
      end
    end
  end
end

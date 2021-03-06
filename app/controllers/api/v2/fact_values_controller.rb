module Api
  module V2
    class FactValuesController < V2::BaseController
      before_action :setup_search_options, :only => :index

      api :GET, "/fact_values/", N_("List all fact values")
      api :GET, "/hosts/:host_id/facts/", N_("List all fact values of a given host")
      param_group :search_and_pagination, ::Api::V2::BaseController
      add_scoped_search_description_for(FactValue)

      def index
        values = FactValue.
          authorized(:view_facts).
          my_facts.
          no_timestamp_facts.
          search_for(*search_options).paginate(paginate_options).
          preload(:fact_name, :host)
        host_id = params[:host_id]
        @fact_values = FactValue.build_facts_hash(values, host_id)
      end
    end
  end
end

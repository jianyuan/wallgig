module Kaminari
  module Helpers
    class Tag
      def page_url_for(page)
        # patch to always include page param
        @template.url_for @template.params.merge(@param_name => (page < 1 ? nil : page))
      end
    end
  end
end

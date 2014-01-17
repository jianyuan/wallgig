module Reportable
  extend ActiveSupport::Concern
  included do
  	has_many :reports, as: :reportable, dependent: :destroy
  end
end

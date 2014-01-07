class WallpaperSearch
  # formula to calculate wallpaper's popularity
  POPULARITY_SCRIPT = "doc['views'].value * 0.5 + doc['favourites'].value * 1.5"

  def initialize(options)
    @options = options
  end

  def wallpapers
    Wallpaper.tire.search nil,
              load: true,
              payload: build_payload,
              page: @options[:page],
              per_page: (@options[:per_page] || Wallpaper.default_per_page)
  rescue Tire::Search::SearchRequestFailed => e
    Rails.logger.error e
    Wallpaper.none
  end

  private
    def build_payload
      payload = {
        :query => {
          :bool => {
            :must => [],
            :must_not => []
          }
        },
        :sort => [],
        :facets => {}
      }

      # Handle query string
      if @options[:q].present?
        payload[:query][:bool][:must] << {
          :query_string => {
            :query => @options[:q],
            :default_operator => 'AND',
            :lenient => true
          }
        }
      end

      # Handle tags
      if @options[:tags].present?
        @options[:tags].each do |tag|
          payload[:query][:bool][:must] << {
            :term => {
              :'tags' => {
                :value => tag.downcase
              }
            }
          }
        end
      end

      # Handle tag exclusions
      if @options[:exclude_tags].present?
        @options[:exclude_tags].each do |tag|
          payload[:query][:bool][:must_not] << {
            :term => {
              :'tags' => {
                :value => tag.downcase
              }
            }
          }
        end
      end

      # Handle purity
      payload[:query][:bool][:must] << {
        :terms => {
          :'purity' => @options[:purity] || ['sfw']
        }
      }

      # Handle width and height
      [:width, :height].each do |a|
        if @options[a].present?
          payload[:query][:bool][:must] << {
            :range => {
              a => {
                :gte => @options[a],
                :boost => 2.0
              }
            }
          }
        end
      end

      # Handle colors
      if @options[:colors].present?
        @options[:colors].each do |color|
          payload[:query][:bool][:must] << {
            :term => {
              :'colors.hex' => {
                :value => color
              }
            }
          }

          payload[:sort] << {
            :'colors.percentage' => {
              :order => 'desc',
              :nested_filter => {
                :term => {
                  :'colors.hex' => color
                }
              }
            }
          }
        end
      end

      case @options[:order]
      when 'random'
        payload[:query][:bool][:must] << {
          :function_score => {
            :functions => [
              {
                :random_score => {
                  :seed => @options[:random_seed] || Time.now.to_i
                }
              }
            ]
          }
        }
        payload[:sort] << '_score'
      when 'popular'
        payload[:query][:bool][:must] << {
          :function_score => {
            :functions => [
              {
                :script_score => {
                  :script => POPULARITY_SCRIPT
                }
              }
            ]
          }
        }
        payload[:sort] << '_score'
      end

      if payload[:sort].empty? && @options[:q].blank?
        payload[:sort] << {
          :'created_at' => 'desc'
        }
      end

      payload[:facets] = {
        :tags => {
          :terms => {
            :field => 'tags',
            :size => 20
          }
        }
      }

      payload
    end
end
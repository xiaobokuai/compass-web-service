# frozen_string_literal: true

module Openapi
  module V2
    module L3
    class ModelOpencheck < Grape::API

      version 'v2', using: :path
      prefix :api
      format :json

      helpers Openapi::SharedParams::Search
      helpers Openapi::SharedParams::AuthHelpers
      helpers Openapi::SharedParams::ErrorHelpers
      helpers Openapi::SharedParams::RestapiHelpers

      rescue_from :all do |e|
        case e
        when Grape::Exceptions::ValidationErrors
          handle_validation_error(e)
        when SearchFlip::ResponseError
          handle_open_search_error(e)
        else
          handle_generic_error(e)
        end
      end

      before { require_token! }
      before do
        token = params[:access_token]
        Openapi::SharedParams::RateLimiter.check_token!(token)
      end
      before { save_tracking_api! }

      resource :opencheck do
        desc 'List openchecker check Data of the project / 获取项目openchecker检查数据', detail: '
        List openchecker check Data of the project,including license compatibility analysis and known vulnerabilities. / 获取项目openchecker检查数据,包括开源许可证信息和漏洞信息',
             tags: ['Metrics Model Data / 模型数据'],
             success: {
               code: 201, model: Openapi::Entities::OpencheckResponse
        }
        params { use :search }
        post :opencheck do
          label, level, filter_opts, sort_opts, begin_date, end_date, page, size = extract_search_params!(params)

          indexer = OpencheckMetric
          repo_urls = [label]

          resp = indexer.terms_by_metric_repo_urls(repo_urls, begin_date, end_date, per: size, page:, filter_opts:, sort_opts:)

          count = indexer.count_by_metric_repo_urls(repo_urls, begin_date, end_date, filter_opts:)

          hits = resp&.[]('hits')&.[]('hits') || []
          items = hits.map { |data| data['_source'].symbolize_keys }

          { count:, total_page: (count.to_f / size).ceil, page:, items: }
        end

      end
    end
    end
  end
end

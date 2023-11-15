# frozen_string_literal: true

module BaseEnrich
  extend ActiveSupport::Concern
  class_methods do
    def terms_by_repo_urls(
          repo_urls, begin_date, end_date,
          target: 'tag', filter: :created_at, sort: :created_at, direction: :asc,
          per: 1, page: 1, filter_opts: [], sort_opts: []
        )
      base =
        self
          .must(terms: { target => repo_urls })
          .range(filter, gte: begin_date, lte: end_date)

      if filter_opts.present?
        filter_opts.each do |filter_opt|
          base = base.where(filter_opt.type => filter_opt.values)
        end
      end

      if sort_opts.present?
        sort_opts.each do |sort_opt|
          base = base.sort(sort_opt.type => sort_opt.direction)
        end
      else
        base = base.sort(sort => direction)
      end

      base
        .page(page)
        .per(per)
        .execute
        .raw_response
    end

    def count_by_repo_urls(
          repo_urls, begin_date, end_date,
          target: 'tag', filter: :created_at, filter_opts: []
        )
      base =
        self
          .must(terms: { target => repo_urls })
          .range(filter, gte: begin_date, lte: end_date)
      if filter_opts.present?
        filter_opts.each do |filter_opt|
          base = base.where(filter_opt.type => filter_opt.values)
        end
      end
      base.total_entries
    end
  end
end
# frozen_string_literal: true

module Types
  module Meta
    class CommitRepoType < Types::BaseObject
      field :repo_name, String
      field :repo_attribute_type, String
      field :lines_added, Integer
      field :lines_removed, Integer
      field :lines_changed, Integer
      field :repo_technology_type, String
    end
  end
end
# frozen_string_literal: true

module Mutations
  class UpdateLabModelVersion < BaseMutation
    field :data, Types::Lab::ModelVersionType, null: true

    argument :model_id, Integer, required: true, description: "lab model id"
    argument :version_id, Integer, required: true, description: "lab model version id"
    argument :version, String, required: false, description: "version string"
    argument :is_score, Boolean, required: false, description: 'whether or not calculate the score, default: false'
    argument :datasets, [Input::DatasetRowTypeInput], required: false, description: 'the collection of the repositories'
    argument :metrics, [Input::LabModelMetricInput], required: false, description: 'lab model metrics'
    argument :algorithm, String, required: false, description: 'the ident of algorithm'

    def resolve(
          model_id: nil,
          version_id: nil,
          version: '',
          is_score:false,
          datasets: [],
          metrics: [],
          algorithm:
        )
      current_user = context[:current_user]

      login_required!(current_user)

      model = LabModel.find_by(id: model_id)
      raise GraphQL::ExecutionError.new I18n.t('lab_models.not_found') unless model.present?

      model_version = model.versions.find_by(id: version_id)
      raise GraphQL::ExecutionError.new I18n.t('lab_models.not_found') unless model_version.present?

      raise GraphQL::ExecutionError.new I18n.t('lab_models.forbidden') unless ::Pundit.policy(current_user, model).update?

      raise GraphQL::ExecutionError.new I18n.t('lab_models.metrics_too_large', limit: LabMetric::Limit) if metrics.length > LabMetric::Limit

      if algorithm.present?
        algorithm = LabAlgorithm.find_by(ident: algorithm)
        raise GraphQL::ExecutionError.new I18n.t('lab_models.invalid_algorithm') unless algorithm.present?
        end

      ActiveRecord::Base.transaction do

        if algorithm.present?
          model_version.update!(algorithm: algorithm)
        end

        if datasets.present?
          model_version.dataset.update_rows!(datasets)
        end

        if metrics.present?
          model_version.bulk_update_or_create!(metrics)
        end

        if version.present?
          model_version.update!(version: version)
        end

        if is_score != nil
          model_version.update!(is_score: is_score)
        end


      end

      { data: model_version }
    rescue => ex
      raise GraphQL::ExecutionError.new I18n.t('lab_models.update_failed', reason: ex.message)
    end
  end
end

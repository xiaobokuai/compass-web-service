# frozen_string_literal: true

module Mutations
  module Tpc
    class TriggerTpcSoftwareLectotypeReport < BaseMutation
      include CompassUtils
      #
      field :status, String, null: false

      argument :report_id, Integer, required: true

      def resolve(report_id: nil)
        current_user = context[:current_user]
        login_required!(current_user)

        lectotype_report = TpcSoftwareLectotypeReport.find_by(id: report_id)
        raise GraphQL::ExecutionError.new I18n.t('basic.subject_not_exist') if lectotype_report.nil?
        raise GraphQL::ExecutionError.new I18n.t('basic.forbidden') unless current_user&.is_admin? || lectotype_report.user_id == current_user.id
        report_metric = lectotype_report.tpc_software_lectotype_report_metrics.find_by(
          # tpc_software_report_type: TpcSoftwareReportMetric::Report_Type_Selection,
          version: TpcSoftwareReportMetric::Version_Default)
        raise GraphQL::ExecutionError.new I18n.t('basic.subject_not_exist') if report_metric.nil?

        ActiveRecord::Base.transaction do
          report_metric.update!(
            {
              status: TpcSoftwareLectotypeReportMetric::Status_Again_Progress,
              status_compass_callback: 0,
              status_tpc_service_callback: 0
            }
          )
          tpc_software_metric_server = TpcSoftwareMetricServer.new({project_url: lectotype_report.code_url})
          tpc_software_metric_server.analyze_metric_by_tpc_service(lectotype_report.id, report_metric.id,lectotype_report.oh_commit_sha, TpcSoftwareMetricServer::Report_Type_Lectotype)
          tpc_software_metric_server.analyze_metric_by_compass(lectotype_report.id, report_metric.id, TpcSoftwareMetricServer::Report_Type_Lectotype)
        end
        #
        { status: true, message: '' }
      rescue => ex
        { status: false, message: ex.message }
      end

    end
  end
end

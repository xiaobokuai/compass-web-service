# frozen_string_literal: true

module Openapi
  module V2
    module L2
      class CommunityPortrait < Grape::API
        version 'v2', using: :path
        prefix :api
        format :json

        helpers Openapi::SharedParams::CustomMetricSearch
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
        resource :community_portrait do

          # 代码
          desc 'Code Maintenance Status / 代码是否维护',
               detail: 'Weekly percentage of code commits in the past 90 days (single repository) or percentage of repositories with at least one commit in the past 30 days (multiple repositories) / 在过去 90 天内至少提交了一次代码的周百分比 (单仓场景)。在过去 30 天内至少有一次代码提交记录的的代码仓百分比 (多仓场景)',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::IsMaintainedResponse
               }

          params { use :community_portrait_search }

          post :is_maintained do
            fetch_metric_data(metric_name: 'is_maintained')
          end

          desc 'Code Commit Frequency / 代码提交频率',
               detail: 'Average weekly code commits in the past 90 days / 过去 90 天内平均每周代码提交次数',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::CommitFrequencyResponse
               }

          params { use :community_portrait_search }

          post :commit_frequency do
            fetch_metric_data(metric_name: 'commit_frequency')
          end

          desc 'Quarterly Code Contribution / 代码季度提交量',
               detail: 'Code contribution volume for each quarter in the past year / 最近1年中每季度的代码贡献量情况',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::ActivityQuarterlyContributionResponse
               }

          params { use :community_portrait_search }

          post :activity_quarterly_contribution do
            fetch_metric_data(metric_name: 'activity_quarterly_contribution')
          end

          desc 'Code Closed Source Permission / 代码是否允许闭源',
               detail: 'Whether users are allowed to close source the modified parts after modifying the source code / 使用者在修改源码后是否允许对修改部分进行闭源',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::LicenseCommercialAllowedResponse
               }

          params { use :community_portrait_search }

          post :license_commercial_allowed do
            fetch_metric_data(metric_name: 'license_commercial_allowed')
          end

          desc 'Code Commit Count / 代码提交量',
               detail: 'Number of code commits in the past 90 days / 在过去 90 天内提交的代码次数',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::CommitCountResponse
               }

          params { use :community_portrait_search }

          post :commit_count do
            fetch_metric_data(metric_name: 'commit_count')
          end

          desc 'Code Commit PR Link Ratio / 代码提交关联PR的比率',
               detail: 'Percentage of code commits linked to PRs in the past 90 days / 在过去 90 天内提交的代码链接 PR 的百分比。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::CommitPrLinkedRatioResponse
               }

          params { use :community_portrait_search }

          post :commit_pr_linked_ratio do
            fetch_metric_data(metric_name: 'commit_pr_linked_ratio')
          end

          desc 'Code Commit PR Link Count / 代码链接PR量',
               detail: 'Number of code commits linked to PRs in the past 90 days / 过去 90 天内提交的代码链接 PR 的次数。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::CommitPrLinkedCountResponse
               }

          params { use :community_portrait_search }

          post :commit_pr_linked_count do
            fetch_metric_data(metric_name: 'commit_pr_linked_count')
          end

          desc 'Code Line Changes / 代码变更行数',
               detail: 'Average weekly lines of code changed (additions plus deletions) in the past 90 days / 过去 90 天内平均每周提交的代码行数 (增加行数加上删除行数)。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::LinesOfCodeFrequencyResponse
               }

          params { use :community_portrait_search }

          post :lines_of_code_frequency do
            fetch_metric_data(metric_name: 'lines_of_code_frequency')
          end

          desc 'Code Lines Added / 代码增加行数',
               detail: 'Average weekly lines of code added in the past 90 days / 确定在过去 90 天内平均每周提交的代码行数 (增加行数)。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::LinesAddOfCodeFrequencyResponse
               }

          params { use :community_portrait_search }

          post :lines_add_of_code_frequency do
            fetch_metric_data(metric_name: 'lines_add_of_code_frequency')
          end

          desc 'Code Lines Deleted / 代码删除行数',
               detail: 'Average weekly lines of code deleted in the past 90 days / 确定在过去 90 天内平均每周提交的代码行数 (删除行数)。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::LinesRemoveOfCodeFrequencyResponse
               }

          params { use :community_portrait_search }

          post :lines_remove_of_code_frequency do
            fetch_metric_data(metric_name: 'lines_remove_of_code_frequency')
          end

          desc 'Organization Count / 组织数量',
               detail: 'Number of organizations that active code contributors belong to in the past 90 days / 过去 90 天内活跃的代码提交者所属组织的数目。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::OrgCountResponse
               }

          params { use :community_portrait_search }

          post :org_count do
            fetch_metric_data(metric_name: 'org_count')
          end

          desc 'Organization Commit Frequency / 组织代码提交频率',
               detail: 'Average weekly code commits from organization-affiliated contributors in the past 90 days / 过去 90 天内平均每周有组织归属的代码提交次数。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::OrgCommitFrequencyResponse
               }

          params { use :community_portrait_search }

          post :org_commit_frequency do
            fetch_metric_data(metric_name: 'org_commit_frequency')
          end

          desc 'The organization continues to contribute / 组织持续贡献',
               detail: 'Cumulative time (weeks) of code contributions from all organizations to the community in the last 90 days / 在过去 90 天所有组织向社区有代码贡献的累计时间（周）',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::OrgContributionLastResponse
               }

          params { use :community_portrait_search }

          post :org_contribution_last do
            fetch_metric_data(metric_name: 'org_contribution_last')
          end

          desc 'Organizational contribution / 组织贡献度',
               detail: 'Evaluate the contribution of organizations and institutions to open source software / 评估组织、机构对开源软件的贡献情况',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::OrgContributionResponse
               }

          params { use :community_portrait_search }

          post :org_contribution do
            fetch_metric_data(metric_name: 'org_contribution')
          end

          desc 'Number of code contributors / 代码贡献者数量',
               detail: 'How many active code committers, code reviewers, and PR committers in the last 90 days / 在过去 90 天内有多少活跃的代码提交者、代码审核者和 PR 提交者',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                  code: 201, model: Openapi::Entities::CodeContributorCountResponse
               }

          params { use :community_portrait_search }
          post :code_contributor_count do
            fetch_metric_data(metric_name: "code_contributor_count")

          end

          desc 'Number of code committers / 代码提交者数量',
               detail: 'The number of active code committers in the last 90 days / 过去 90 天中活跃的代码提交者的数量',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::CommitContributorCountResponse
               }
          params { use :community_portrait_search }
          post :commit_contributor_count do
            fetch_metric_data(metric_name: 'commit_contributor_count')
          end

          # Issue
          desc 'Issue first response time / Issue 首次响应时间',
               detail: 'Mean and median (days) time to first response to a new issue over the last 90 days. This does not include bot responses, the creator own comments, or the assignment of actions to issues. If an issue has not been answered, it will not be counted. / 过去 90 天新建 Issue 首次响应时间的均值和中位数（天）。这不包括机器人响应、创建者自己的评论或 Issue 的分配动作（action）。如果 Issue 一直未被响应，该 Issue 不被算入统计。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::IssueFirstResponseResponse
               }

          params { use :community_portrait_search }
          post :commit_contributor_count do
            fetch_metric_data(metric_name: "commit_contributor_count")
          end


          desc 'The processing time of the issue bug class / Issue Bug类处理时间',
               detail: 'The mean and median number of new bug issues in the last 90 days (days), including closed issues and open issues. / 过去 90 天新建的 Bug 类 Issue 处理时间的均值和中位数（天），包含已经关闭的 Issue 以及未解决的 Issue。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::IssueBugOpenTimeResponse
               }

          params { use :community_portrait_search }

          post :bug_issue_open_time do
            fetch_metric_data(metric_name: 'bug_issue_open_time')
          end

          desc 'Issue comment frequency / Issue评论频率',
               detail: 'Average number of comments on new issues in the last 90 days (excluding bots and issue authors) / 过去 90 天内新建 Issue 的评论平均数（不包含机器人和 Issue 作者本人评论）',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::CommentFrequencyResponse
               }

          params { use :community_portrait_search }

          post :comment_frequency do
            fetch_metric_data(metric_name: 'comment_frequency')
          end

          desc 'Number of issues closed / Issue关闭数量',
               detail: 'The number of closed issues in the last 90 days / 过去 90 天关闭 Issue 的数量。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::ClosedIssuesCountResponse
               }
          params { use :community_portrait_search }

          post :closed_issues_count do
            fetch_metric_data(metric_name: 'closed_issues_count')
          end

          desc 'The number of issues that have been updated / Issue更新数量',
               detail: 'The number of issue updates in the last 90 days. / 过去 90 天 Issue 更新的数量。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::UpdatedIssuesCountResponse
               }

          params { use :community_portrait_search }
          post :updated_issues_count do
            fetch_metric_data(metric_name: 'updated_issues_count')
          end

          desc 'Number of issue authors / Issue作者数量',
               detail: 'The number of active issue authors in the last 90 days / 过去 90 天中活跃的 Issue 作者的数量',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::IssueAuthorsContributorCountResponse
               }
          params { use :community_portrait_search }
          post :issue_authors_contributor_count do
            fetch_metric_data(metric_name: 'issue_authors_contributor_count')
          end

          desc 'Number of commenters on Issue / Issue评论者数量',
               detail: 'The number of active issue commenters in the last 90 days / 过去 90 天中活跃的 Issue 评论者的数量',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::IssueCommentsContributorCountResponse
               }
          params { use :community_portrait_search }
          post :issue_comments_contributor_count do
            fetch_metric_data(metric_name: 'issue_comments_contributor_count')
          end

          # PR
          desc 'PR Processing Time / PR处理时间',
               detail: 'Mean and median processing time (in days) for new PRs in the past 90 days, including closed and unresolved PRs / 过去 90 天新建 PR 的处理时间的均值和中位数（天），包含已经关闭的 PR 以及未解决的 PR。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::PrOpenTimeResponse
               }
          params { use :community_portrait_search }
          post :pr_open_time do
            fetch_metric_data(metric_name: 'pr_open_time')
          end

          desc 'PR Review Comment Frequency / PR审查评论频率',
               detail: 'Average number of comments on new PRs in the past 90 days (excluding bot and PR author comments) / 过去 90 天内新建 PR 的评论平均数量（不包含机器人和 PR 作者本人评论）。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::CodeReviewCountResponse
               }

          params { use :community_portrait_search }
          post :issue_authors_contributor_count do
            fetch_metric_data(metric_name: "issue_authors_contributor_count")
          end


          # PR

          desc 'PR Closure Count / PR关闭数量',
               detail: 'Number of merged and rejected PRs in the past 90 days / 过去 90 天内合并和拒绝的 PR 数量。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::ClosePrCountResponse
               }

          params { use :community_portrait_search }

          post :close_pr_count do
            fetch_metric_data(metric_name: 'close_pr_count')
          end

          desc 'PR First Response Time / PR首次响应时间',
               detail: 'Time interval from PR creation to first human response in the past 90 days / 在过去 90 天内，从创建 PR 到首次收到人工回复的时间间隔。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::PrTimeToFirstResponseResponse
               }

          params { use :community_portrait_search }

          post :pr_time_to_first_response do
            fetch_metric_data(metric_name: 'pr_time_to_first_response')
          end

          desc 'PR Total Closure Ratio / PR闭环总比率',
               detail: 'Ratio between total PRs and closed PRs from the beginning to now / 从开始到现在 PR 总数与关闭的 PR 数之间的比率。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::ChangeRequestClosureRatioResponse
               }

          params { use :community_portrait_search }

          post :change_request_closure_ratio do
            fetch_metric_data(metric_name: 'change_request_closure_ratio')
          end

          desc 'PR Review Ratio / PR审查比率',
               detail: 'Percentage of code submissions with at least one reviewer (not PR creator) in the past 90 days / 过去 90 天内提交代码中，至少包含一名审核者 (不是 PR 创建者) 的百分比。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::CodeReviewRatioResponse
               }
          params { use :community_portrait_search }
          post :code_review_ratio do
            fetch_metric_data(metric_name: 'code_review_ratio')
          end

          desc 'PR Creation Count / PR创建数量',
               detail: 'Number of PRs created in the past 90 days / 过去 90 天内创建的 PR 的数量。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::PrCountResponse
               }

          params { use :community_portrait_search }

          post :pr_count do
            fetch_metric_data(metric_name: 'pr_count')
          end

          desc 'PR Review Count / PR审查数量',
               detail: 'Number of PRs reviewed in the past 90 days / 在过去 90 天内审查的 PR 数量。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::PrCountWithReviewResponse
               }

          params { use :community_portrait_search }

          post :pr_count_with_review do
            fetch_metric_data(metric_name: 'pr_count_with_review')
          end

          desc 'PR Merge Ratio / PR合并比率',
               detail: 'Percentage of PRs where merger and author are different people in the past 90 days / 过去 90 天提交代码中，PR 合并者和 PR 作者不属于同一人的百分比。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::CodeMergeRatioResponse
               }

          params { use :community_portrait_search }

          post :code_merge_ratio do
            fetch_metric_data(metric_name: 'code_merge_ratio')
          end

          desc 'PR Issue Link Ratio / PR关联Issue的比率',
               detail: 'Percentage of new PRs linked to issues in the past 90 days / 过去 90 天内新建 PR 关联 Issue 的百分比。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::PrIssueLinkedRatioResponse
               }

          params { use :community_portrait_search }

          post :pr_issue_linked_ratio do
            fetch_metric_data(metric_name: 'pr_issue_linked_ratio')
          end

          desc 'PR Total Accepted or Rejected Count / PR已接受或拒绝总数',
               detail: 'Total number of PRs created and either accepted or rejected from the beginning / 从开始到现在创建的 PR 并且被接受或拒绝的数量。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::TotalCreateClosePrCountResponse
               }

          params { use :community_portrait_search }

          post :total_create_close_pr_count do
            fetch_metric_data(metric_name: 'total_create_close_pr_count')
          end

          desc 'Total PR Count / PR总数',
               detail: 'Total number of PRs created from the beginning / 从开始到现在新建 PR 数量。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::TotalPrCountResponse
               }

          params { use :community_portrait_search }

          post :total_pr_count do
            fetch_metric_data(metric_name: 'total_pr_count')
          end

          desc 'The number of PRs accepted or rejected / PR已接受或拒绝数量',
               detail: 'The number of PRs created in the last 90 days that were accepted or rejected. / 过去 90 天内创建的 PR 并且被接受或拒绝的数量。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::CreateClosePrCountResponse
               }

          params { use :community_portrait_search }

          post :create_close_pr_count do
            fetch_metric_data(metric_name: 'create_close_pr_count')
          end

          desc 'Number of PR merges (non-PR authors merge) / PR合并数量(非PR作者合并)',
               detail: 'The number of PRs merged in the last 90 days (excluding the PR author own merge). / 过去 90 天内 PR 合并数量（不包含 PR 作者本人合并）。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::CodeMergeCountWithNonAuthorResponse
               }
          params { use :community_portrait_search }
          post :code_merge_count_with_non_author do
            fetch_metric_data(metric_name: 'code_merge_count_with_non_author')
          end

          desc 'The number of issues associated with PRs / PR关联Issue数量',
               detail: 'Number of PR-related issues: The number of new PR-related issues in the last 90 days. / PR关联Issue数量: 过去 90 天内新建 PR 关联 Issue 的数量。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::PrIssueLinkedCountResponse
               }
          params { use :community_portrait_search }
          post :pr_issue_linked_count do

            fetch_metric_data(metric_name: 'pr_issue_linked_count')
          end

          desc 'Number of PR authors / PR作者数量',
               detail: 'Number of Pull Request Authors. / Pull Request 作者数量。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::PrAuthorsContributorCountResponse
               }
          params { use :community_portrait_search }
          post :pr_authors_contributor_count do
            fetch_metric_data(metric_name: 'pr_authors_contributor_count')
          end

          desc 'Number of PR reviewers / PR审查者数量',
               detail: 'The number of active code reviewers in the last 90 days / 过去 90 天中活跃的代码审查者的数量',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::PrReviewContributorCountResponse
               }
          params { use :community_portrait_search }
          post :pr_review_contributor_count do
            fetch_metric_data(metric_name: 'pr_review_contributor_count')
          end

          # 仓库
          desc 'The repository is created in / 仓库创建于',
               detail: 'How long the repository has been in existence since it was created (months) / 代码仓自创建以来存在了多长时间 (月份)',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::CreatedSinceResponse
               }
          params { use :community_portrait_search }
          post :created_since do
            fetch_metric_data(metric_name: 'created_since')
          end

          desc 'The repository is updated on / 仓库更新于',
               detail: 'The average amount of time (days) since the last update for each repository, i.e., how long it has not been updated / 每个代码仓自上次更新以来的平均时间 (天)，即多久没更新了',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::UpdatedSinceResponse
               }
          params { use :community_portrait_search }
          post :updated_since do
            fetch_metric_data(metric_name: 'updated_since')
          end

          desc 'Repository Open Source License Change Statement / 仓库开源许可证变更声明',
               detail: 'Evaluate whether changes to open source software open source licenses require a declaration to users. / 评估开源软件开源许可证发生变更时是否需向用户进行声明。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::LicenseChangeClaimsRequiredResponse
               }
          params { use :community_portrait_search }
          post :license_change_claims_required do
            fetch_metric_data(metric_name: 'license_change_claims_required')
          end

          desc 'Repository Permissive or Weak Copyleft License / 仓库宽松型或弱著作权开源许可证',
               detail: 'Evaluate whether the project has a permissive or weak copyleft open source license / 评估项目是否为宽松型开源许可证或弱著作权开源许可证。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::LicenseIsWeakResponse
               }
          params { use :community_portrait_search }
          post :license_is_weak do
            fetch_metric_data(metric_name: 'license_is_weak')
          end

          desc 'Recent Release Count / 仓库最近版本发布次数',
               detail: 'Number of releases in the past 12 months / 过去 12 个月版本发布的数量',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::RecentReleasesCountResponse
               }
          params { use :community_portrait_search }
          post :recent_releases_count do
            fetch_metric_data(metric_name: 'recent_releases_count')
          end

          # 贡献者
          desc 'Contributor Count / 贡献者数量',
               detail: 'Number of active code committers, PR authors, code reviewers, issue authors and issue commenters in the past 90 days / 过去 90 天中活跃的代码提交者、Pull Request 作者、代码审查者、Issue 作者和 Issue 评论者的数量。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::ContributorCountResponse
               }
          params { use :community_portrait_search }
          post :contributor_count do
            fetch_metric_data(metric_name: 'contributor_count')
          end



          desc 'Contributor Bus Factor / 贡献者Bus Factor',
               detail: 'Minimum number of contributors accounting for 50% of contributions in the past 90 days / 过去 90 天内贡献占 50% 的最小人数。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::BusFactorResponse
               }
          params { use :community_portrait_search }
          post :bus_factor do
            fetch_metric_data(metric_name: 'bus_factor')
          end


          desc 'Organization Contributor Count / 组织贡献者数量',
               detail: 'Number of active code contributors with organizational affiliations in the past 90 days / 过去 90 天内有组织附属关系的活跃的代码贡献者人数。',
               tags: ['Metrics Data / 指标数据', 'Community Persona / 社区画像'],
               success: {
                 code: 201, model: Openapi::Entities::OrgContributorCountResponse
               }
          params { use :community_portrait_search }
          post :org_contributor_count do
            fetch_metric_data(metric_name: 'org_contributor_count')
          end
        end
      end
    end
  end
end

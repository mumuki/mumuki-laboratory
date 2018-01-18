module RunnerAssetsHelper
  def render_runner_assets(language, assets_kind)
    render partial: 'layouts/runner_assets', locals: {language: language, assets_kind: assets_kind}
  end
end

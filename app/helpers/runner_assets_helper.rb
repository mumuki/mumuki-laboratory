module RunnerAssetsHelper
  def render_runner_assets(language, assets_kind, loads_more_assets=false)
    render partial: 'layouts/runner_assets', locals: {language: language, assets_kind: assets_kind, loads_more_assets: loads_more_assets}
  end

  def show_loading_for?(language, assets_kind)
    language.send("#{assets_kind}_shows_loading_content")
  end
end

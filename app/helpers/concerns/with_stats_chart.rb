module WithStatsChart
  def stats_chart(stats)
    # FIXME use standard colors
    pie_chart stats.to_h { |it| t(it) }, colors: %w(green yellow red grey)
  end
end

module TimeZoneHelper
  def local_time(time, time_zone = Time.zone.name)
    "#{local_time_without_time_zone(time, time_zone)} (#{time_zone})"
  end

  def local_time_without_time_zone(time, time_zone = Time.zone.name)
    l(time.in_time_zone(time_zone), format: :long)
  end
end

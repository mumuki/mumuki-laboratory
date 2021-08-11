module TimeZoneHelper
  def local_time(time, time_zone = Time.zone.name)
    "#{l(time.in_time_zone(time_zone), format: :long)} (#{time_zone})"
  end
end

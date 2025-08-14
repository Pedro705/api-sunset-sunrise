module DateConcern
  extend ActiveSupport::Concern

  class_methods do
    def time_to_seconds(time_str)
      hours, minutes, seconds = time_str.split(":").map(&:to_i)
      (hours * 3600) + (minutes * 60) + seconds
    end

    def parse_time_with_date(time_string, date)
      return nil if time_string.blank? || date.blank?

      time_part = Time.parse(time_string)
      DateTime.new(date.year, date.month, date.day, time_part.hour, time_part.min, time_part.sec)
    end

    def validate_date_string(date)
      return date if date.is_a?(Date) || date.is_a?(DateTime)

      Date.parse(date.to_s)
    rescue
      nil
    end
  end
end

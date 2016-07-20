Date::DATE_FORMATS[:header] = Proc.new { |date| date.format_like("Tue 19 Jul") }
Date::DATE_FORMATS[:hour] = Proc.new { |date| date.format_like("5 PM") }

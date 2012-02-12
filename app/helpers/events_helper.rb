require 'date'

module EventsHelper
  def convert(weird_string)
    ms = weird_string.split("+")[0]
    ms = ms.split("(")[1]
    return DateTime.strptime(ms[0..-4], '%s')
  end
end

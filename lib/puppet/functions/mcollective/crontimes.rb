Puppet::Functions.create_function(:'mcollective::crontimes') do
  dispatch :crontimes do
    required_param 'Integer', :offset
    required_param 'Integer', :interval
    required_param 'Integer', :period
  end

  def crontimes(offset, interval, period)
    (period / interval).times.map do |i|
      val = i * interval + offset

      val if val < period && val < 60
    end.compact
  end
end

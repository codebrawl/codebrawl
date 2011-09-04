require 'time'
require 'active_support/core_ext/time/calculations'
require 'active_support/core_ext/date/conversions'

module TimeFromDateField

  def self.included(base)

    base.instance_methods.each do |method|

      base.send(:define_method, "#{$1}_at") do
        send(method).to_time(:utc) + 50400 # 14 hours
      end if method =~ /^(.*)_on$/

    end

  end

end

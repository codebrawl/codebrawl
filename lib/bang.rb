module Bang

  def bang(attributes)

    [*attributes].each do |attribute|
      key, value = attribute

      define_method("#{key}!") do
        update_attribute(value || key, send(key))
      end
    end

  end

end

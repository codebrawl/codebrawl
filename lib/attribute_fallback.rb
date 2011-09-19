module AttributeFallback

  def fallback(attribute, fallback)

    define_method(attribute) do
      read_attribute(attribute) || read_attribute(fallback)
    end

  end

end

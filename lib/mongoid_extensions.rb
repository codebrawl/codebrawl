module MongoidExtensions

  def not_found
    raise Mongoid::Errors::DocumentNotFound.new(self.class, id)
  end

end

Mongoid::Document.send(:include, MongoidExtensions)

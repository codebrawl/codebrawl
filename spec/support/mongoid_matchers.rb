module MongoidMatchers

  def be_embedded_in(name)
    BeEmbeddedIn.new(name)
  end

  class BeEmbeddedIn

    def initialize(name)
      @name = name
    end

    def matches?(subject)
      @subject = subject
      association_exists? && macro_correct?
    end

    def model_class
      @subject.class
    end

    def reflection
      @reflection ||= model_class.reflect_on_association(@name)
    end

    def association_exists?
      if reflection.nil?
        @missing = "no association called #{@name}"
        false
      else
        true
      end
    end

    def macro_correct?
      if reflection.macro == :embedded_in
        true
      else
        @missing = "actual association type was #{reflection.macro}"
        false
      end
    end

    def description
      "be embedded in #{@name}"
    end

    def failure_message
      "Expected #{model_class.name} to be embedded in #{@name} (#{@missing})"
    end

  end

end

RSpec::Matchers.send(:include, MongoidMatchers)

#-------------------------------------------------------------------------------
#
# TransamGeometryFactory
#
# Generic API for creating and managing geometry within TransAM. This API loads
# an adapter that implements the API for one of the following spatial gems:
#
#  rgeo
#  georuby
#
#  depending on the needs of the installation
#
#-------------------------------------------------------------------------------
class TransamGeometryFactory

  attr_reader :geometry_adapter
  attr_reader :klass

  # Define on self, since it's  a class method
  def method_missing(method_sym, *arguments)
    #puts method_sym
    #puts *arguments.inspect
    # see if the adapter responds to the method call
    if method_sym.to_s =~ /^create_(.*)$/
      method_object = geometry_adapter.method(method_sym)
      method_object.call(*arguments)
    else
      super
    end
  end

  # It's important to know Object defines respond_to to take two parameters: the method to check, and whether to include private methods
  # http://www.ruby-doc.org/core/classes/Object.html#M000333
  def respond_to?(method_sym, include_private = false)
    if method_sym.to_s =~ /^create_(.*)$/
      geometry_adapter.respond_to? method_sym
    else
      super
    end
  end

  def initialize(adapter_type, klass = nil, column_name = nil)
    if adapter_type == 'rgeo'
      @geometry_adapter = RgeoGeometryAdapter.new(klass, column_name)
    elsif adapter_type == 'georuby'
      @geometry_adapter = GeorubyGeometryAdapter.new
    else
      RaiseException "Geometry Adapter #{adapter_type} not found."
    end
  end
end

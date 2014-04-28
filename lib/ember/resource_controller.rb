module Ember
end

module Ember::ResourceController
  def self.plural_actions
    [:index]
  end

  def self.singular_actions
    [:show, :destroy, :update, :create]
  end

  def self.resource name
    @resource_name = name
  end

  def index
    render_json all_resources    
  end

  def show
    render_json single_resource
  end

  def destroy    
    render_json single_resource.destroy
  end

  def update        
    render_json single_resource.update(params)
  end

  def create    
    render_json single_resource.save
  end

  protected

  def render_json data, opts = {}
    render json: data, opts
  end

  def new_resource
    @new_resource ||= resource_class.new params
  end

  def all_resources
    resource_class.all.to_a
  end

  def resource
    @resource ||= resource_class.find resource_id
  end

  def resource_id
    params[:id]
  end

  def params
    params[resource_name.to_sym]
  end 

  def controller_resource_name
    @@resource_name || this.clazz.to_s.gsub(/Controller$/, '').demodulize
  end

  def resource_class
    resource_class_name.constantize
  end

  def resource_class_name
    controller_resource_name.camelize
  end

  def resource_name
    @@resource_name || controller_resource_name.singularize
  end

  def single_resource
    send resource_name.singularize
  end

  def all_resources
    send  resource_name.pluralize
  end
end
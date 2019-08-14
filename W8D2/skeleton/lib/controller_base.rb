require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    @res.status = 302
    @res.location = url
    @session.store_session(@res)
    if @already_built_response == true
      raise 'already rendered'
    else
      @already_built_response = true
    end
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    @res['Content-Type'] = content_type
    @res.body = [content]
    @session.store_session(@res)
    if @already_built_response == true
      raise 'already rendered'
    else
      @already_built_response = true
    end

  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    class_name = self.class.to_s.split /(?=[A-Z])/
    controller_name = class_name[0].downcase
    temp_path = "./views/#{controller_name}_controller/#{template_name}.html.erb"
    contents = File.read(temp_path)
    new_content = ERB.new(contents).result(binding)
    render_content(new_content, 'text/html')

  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)

  end
end

